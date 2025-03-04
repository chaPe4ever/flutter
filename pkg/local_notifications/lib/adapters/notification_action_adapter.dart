import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifications/contracts/notification_action_base.dart';

class NotificationActionAdapter extends NotificationActionBase {
  const NotificationActionAdapter({
    required super.id,
    required super.title,
    required super.titleColor,
  });

  AndroidNotificationAction adapt() {
    return AndroidNotificationAction(id, title, titleColor: titleColor);
  }
}
