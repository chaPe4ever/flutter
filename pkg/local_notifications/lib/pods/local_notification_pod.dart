import 'package:core/core.dart' hide id;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifications/contracts/local_notifications_base.dart';
import 'package:local_notifications/contracts/notification_action_base.dart';
import 'package:local_notifications/exceptions/local_notifications_exceptions.dart';
import 'package:local_notifications/implementations/local_notifications_impl.dart';
import 'package:local_notifications/pods/flutter_notification_plugin_pod.dart';

part 'local_notification_pod.g.dart';

@Riverpod(keepAlive: true)
class LocalNotifications extends _$LocalNotifications {
  LocalNotificationsBase? _notifications;
  bool _isInitialized = false;
  @override
  FutureOr<void> build() {
    _notifications = LocalNotificationsImpl(
      notifications: ref.watch(flutterLocalNotificationsPluginPod),
    );
  }

  Future<void> init({
    void Function(NotificationResponse)?
    onDidReceiveBackgroundNotificationResponse,
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
  }) async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard<void>(() async {
      try {
        if (_notifications == null) {
          throw const LocalNotificationsInitException(
            innerError: 'LocalNotifications is not initialized',
          );
        }
        await _notifications?.init(
          onDidReceiveBackgroundNotificationResponse:
              onDidReceiveBackgroundNotificationResponse,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        );
      } catch (e) {
        throw e.toCoreException(
          customEx: LocalNotificationsInitException(innerError: e),
        );
      }
    });
  }

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
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard<void>(() async {
      if (!_isInitialized) {
        throw const LocalNotificationsInitException(
          innerError: 'LocalNotifications is not initialized',
        );
      }
      try {
        await _notifications?.showNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
          actions: actions,
          channelId: channelId,
          sound: sound,
          gorupKey: gorupKey,
          badgeNumber: badgeNumber,
        );
      } catch (e) {
        throw LocalNotificationsShowException(innerError: e);
      }
    });
  }

  Future<void> cancelNotificaiton({int id = 0}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard<void>(() async {
      if (!_isInitialized) {
        throw const LocalNotificationsInitException(
          innerError: 'LocalNotifications is not initialized',
        );
      }
      await _notifications?.cancelNotification(id: id);
    });
  }

  Future<void> cancelAllNotificaitons() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard<void>(() async {
      if (!_isInitialized) {
        throw const LocalNotificationsInitException(
          innerError: 'LocalNotifications is not initialized',
        );
      }
      await _notifications?.cancelAllNotifications();
    });
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
