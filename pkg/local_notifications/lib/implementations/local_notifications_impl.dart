import 'package:core/value_objects/unique_id.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifications/adapters/notification_response_adapter.dart';
import 'package:local_notifications/contracts/local_notifications_base.dart';
import 'package:local_notifications/contracts/notification_action_base.dart';
import 'package:local_notifications/contracts/notification_respponse_base.dart';
import 'package:local_notifications/pods/local_notification_pod.dart';

class LocalNotificationsImpl implements LocalNotificationsBase {
  const LocalNotificationsImpl({required this.notifications});

  final FlutterLocalNotificationsPlugin notifications;

  @override
  Future<void> init({
    void Function(NotificationResponseBase)?
    onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponseBase)? onDidReceiveNotificationResponse,
  }) async {
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
    await notifications.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse == null
              ? null
              : (details) {
                onDidReceiveBackgroundNotificationResponse.call(
                  NotificationResponseAdapter.adapt(details),
                );
              },
      onDidReceiveNotificationResponse:
          onDidReceiveNotificationResponse == null
              ? null
              : (details) {
                onDidReceiveNotificationResponse.call(
                  NotificationResponseAdapter.adapt(details),
                );
              },
    );

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
    required int id,
    String gorupKey = 'com.gameroom/local_notifications',
    String? payload,
    List<NotificationActionBase>? actions,
    String? channelId,
    String? sound,
    int? badgeNumber,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId ?? UniqueId().requireValue,
      'channelName',
      channelDescription: 'channelDescription',
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
  Future<void> cancelNotification({required int id}) async {
    await notifications.cancel(id);
  }
}
