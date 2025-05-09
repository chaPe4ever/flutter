import 'dart:async';

import 'package:local_notifications/local_notifications.dart';

abstract interface class LocalNotificationsBase {
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
    String? payload,
    List<NotificationActionBase>? actions,
    String? channelId,
    String? sound,
    String gorupKey = 'com.gameroom/local_notifications',
    int? badgeNumber,
  });

  Future<void> init({
    void Function(NotificationResponse)?
    onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
  });

  Future<void> cancelNotification({int id = 0});
  Future<void> cancelAllNotifications();

  StreamController<NotificationResponse>? fgNotificationController;
  StreamController<NotificationResponse>? bgNotificationController;

  void dispose();

  /// Handle incoming messages
  Future<void> messageHanlder({
    void Function(NotificationResponse message)? onFgMessage,
    void Function(NotificationResponse message)? onBgMessage,
  });
}
