import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications/adapters/notification_action_adapter.dart';

void main() {
  group('NotificationActionAdapter', () {
    test('adapt builds an Android notification action', () {
      const adapter = NotificationActionAdapter(
        id: 'open',
        title: 'Open',
        titleColor: Color(0xFF112233),
      );

      final action = adapter.adapt();

      expect(action, isA<AndroidNotificationAction>());
      expect(action.id, 'open');
      expect(action.title, 'Open');
      expect(action.titleColor, const Color(0xFF112233));
    });
  });
}
