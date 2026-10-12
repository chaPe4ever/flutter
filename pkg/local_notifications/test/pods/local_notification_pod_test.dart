import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications/implementations/local_notifications_impl.dart';
import 'package:local_notifications/pods/local_notification_pod.dart';

void main() {
  group('localNotificationsPod', () {
    test(
      'build wires LocalNotificationsImpl and disposes on container dispose',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifications = container.read(localNotificationsPod);

        expect(notifications, isA<LocalNotificationsImpl>());
        expect(container.dispose, returnsNormally);
      },
    );
  });

  group('AndroidNotificationActionAdapter', () {
    test('adapt builds an Android notification action', () {
      const adapter = AndroidNotificationActionAdapter(
        id: 'dismiss',
        title: 'Dismiss',
        titleColor: Color(0xFF445566),
      );

      final action = adapter.adapt();

      expect(action, isA<AndroidNotificationAction>());
      expect(action.id, 'dismiss');
      expect(action.title, 'Dismiss');
      expect(action.titleColor, const Color(0xFF445566));
    });
  });
}
