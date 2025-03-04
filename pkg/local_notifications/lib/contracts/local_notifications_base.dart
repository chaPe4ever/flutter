import 'package:local_notifications/contracts/notification_action_base.dart';
import 'package:local_notifications/contracts/notification_respponse_base.dart';

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
    void Function(NotificationResponseBase)?
    onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponseBase)? onDidReceiveNotificationResponse,
  });

  Future<void> cancelNotification({required int id});
  Future<void> cancelAllNotifications();
}
