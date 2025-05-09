import 'package:core/core.dart' hide id;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifications/contracts/local_notifications_base.dart';
import 'package:local_notifications/contracts/notification_action_base.dart';
import 'package:local_notifications/implementations/local_notifications_impl.dart';
import 'package:local_notifications/pods/flutter_notification_plugin_pod.dart';

part 'local_notification_pod.g.dart';

@Riverpod(keepAlive: true)
class LocalNotifications extends _$LocalNotifications {
  @override
  LocalNotificationsBase build() {
    final localNotifications = LocalNotificationsImpl(
      notifications: ref.watch(flutterLocalNotificationsPluginPod),
    );
    ref.onDispose(localNotifications.dispose);

    return localNotifications;
  }
}

class AndroidNotificationActionAdapter extends NotificationActionBase {
  const AndroidNotificationActionAdapter({
    required super.id,
    required super.title,
    required super.titleColor,
  });

  AndroidNotificationAction adapt() {
    return AndroidNotificationAction(id, title, titleColor: titleColor);
  }
}
