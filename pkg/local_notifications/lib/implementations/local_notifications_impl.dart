import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifications/contracts/local_notifications_base.dart';
import 'package:local_notifications/contracts/notification_action_base.dart';
import 'package:local_notifications/pods/local_notification_pod.dart';

class LocalNotificationsImpl implements LocalNotificationsBase {
  LocalNotificationsImpl({required this.notifications})
    : fgNotificationController = StreamController<NotificationResponse>(),
      bgNotificationController = StreamController<NotificationResponse>();

  final FlutterLocalNotificationsPlugin notifications;
  @override
  StreamController<NotificationResponse>? fgNotificationController;
  @override
  StreamController<NotificationResponse>? bgNotificationController;

  StreamSubscription<NotificationResponse>? _fgNotificationSubscription;
  StreamSubscription<NotificationResponse>? _bgNotificationSubscription;

  @override
  void dispose() {
    fgNotificationController?.close();
    bgNotificationController?.close();
    _fgNotificationSubscription?.cancel();
    _fgNotificationSubscription = null;
    _bgNotificationSubscription?.cancel();
    _bgNotificationSubscription = null;
  }

  @override
  Future<void> init({
    void Function(NotificationResponse)?
    onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
  }) async {
    assert(
      onDidReceiveBackgroundNotificationResponse != null &&
              onDidReceiveNotificationResponse != null ||
          onDidReceiveBackgroundNotificationResponse == null &&
              onDidReceiveNotificationResponse == null,
      'onDidReceiveBackgroundNotificationResponse and onDidReceiveNotificationResponse must be null or not null at the same time',
    );
    const initAndroidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initIosSettings = DarwinInitializationSettings();

    const initMacOSSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIosSettings,
      macOS: initMacOSSettings,
    );
    if (onDidReceiveBackgroundNotificationResponse != null &&
        onDidReceiveNotificationResponse != null) {
      await notifications.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );
    } else {
      await notifications.initialize(initializationSettings);
    }

    final _ = switch (defaultTargetPlatform) {
      TargetPlatform.android =>
        await notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission(),
      TargetPlatform.iOS => await notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true),
      TargetPlatform.macOS => await notifications
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true),
      _ => throw UnimplementedError(),
    };
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
    String gorupKey = 'ai.gameroom.client/local_notifications',
    String? payload,
    List<NotificationActionBase>? actions,
    String? channelId,
    String? sound,
    int? badgeNumber,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId ?? 'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications',
      groupKey: gorupKey,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      sound: sound == null ? null : RawResourceAndroidNotificationSound(sound),
      actions:
          actions
              ?.cast<AndroidNotificationActionAdapter>()
              .map((action) => action.adapt())
              .toList(),
    );
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentSound: true,
      presentBadge: true,
      presentList: true,
      badgeNumber: badgeNumber,
      sound: sound,
      threadIdentifier: channelId,
      interruptionLevel: InterruptionLevel.active,
    );
    final macosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentSound: true,
      presentBadge: true,
      presentList: true,
      badgeNumber: badgeNumber,
      sound: sound,
      threadIdentifier: channelId,
      categoryIdentifier: gorupKey,
      interruptionLevel: InterruptionLevel.active,
    );
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macosDetails,
    );
    await notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  @override
  Future<void> cancelAllNotifications() async {
    await notifications.cancelAll();
  }

  @override
  Future<void> cancelNotification({int id = 0}) async {
    await notifications.cancel(id);
  }

  @override
  Future<void> messageHanlder({
    void Function(NotificationResponse message)? onFgMessage,
    void Function(NotificationResponse message)? onBgMessage,
  }) async {
    await _fgNotificationSubscription?.cancel();
    _fgNotificationSubscription = fgNotificationController?.stream.listen((
      message,
    ) {
      onFgMessage?.call(message);
    });
    await _bgNotificationSubscription?.cancel();
    _bgNotificationSubscription = bgNotificationController?.stream.listen((
      message,
    ) {
      onBgMessage?.call(message);
    });
  }
}
