import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications/constants/local_notifications_constants.dart';
import 'package:local_notifications/constants/trans_keys_constants.dart';
import 'package:local_notifications/exceptions/local_notifications_exceptions.dart';

void main() {
  group('LocalNotificationsEx', () {
    test('uses the package prefix by default', () {
      const exception = LocalNotificationsInitException();

      expect(exception.prefix, kLocalNotificationsPkgName);
      expect(
        exception.messageKey,
        TransKeys.localNotificationsNotInitialisedKey,
      );
    });

    test('init exception stringifies with the default message key', () {
      expect(
        const LocalNotificationsInitException().toString(),
        '$kLocalNotificationsPkgName : '
        '${TransKeys.localNotificationsNotInitialisedKey}',
      );
    });

    test('show exception uses the show-failed message key', () {
      const exception = LocalNotificationsShowException();

      expect(exception.messageKey, TransKeys.localNotificationsShowFailedKey);
      expect(
        exception.toString(),
        '$kLocalNotificationsPkgName : '
        '${TransKeys.localNotificationsShowFailedKey}',
      );
    });

    test('forwards inner error details to CoreException.toString', () {
      final inner = StateError('plugin down');
      expect(
        LocalNotificationsShowException(
          innerMessage: 'could not show',
          innerError: inner,
        ).toString(),
        '$kLocalNotificationsPkgName : '
        '${TransKeys.localNotificationsShowFailedKey} '
        '(could not show | Bad state: plugin down)',
      );
    });
  });
}
