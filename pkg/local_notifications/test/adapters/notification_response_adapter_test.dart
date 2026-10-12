import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications/adapters/notification_response_adapter.dart';

void main() {
  group('NotificationResponseAdapter', () {
    test('adapt copies id and payload from the plugin response', () {
      const response = NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        id: 7,
        payload: 'deeplink',
      );

      final adapted = NotificationResponseAdapter.adapt(response);

      expect(adapted.id, 7);
      expect(adapted.payload, 'deeplink');
    });

    test('adapt preserves null id and payload', () {
      const response = NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
      );

      final adapted = NotificationResponseAdapter.adapt(response);

      expect(adapted.id, isNull);
      expect(adapted.payload, isNull);
    });
  });
}
