import 'package:local_notifications/local_notifications.dart';

abstract class LocalNotificationsBase {
  Future<void> showNotification({
    required String title,
    required String body,
    required int id,
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

  Future<void> cancelNotification({required int id});
  Future<void> cancelAllNotifications();
}
