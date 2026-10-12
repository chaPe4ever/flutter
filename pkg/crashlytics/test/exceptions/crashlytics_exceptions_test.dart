import 'package:crashlytics/exceptions/crashlytics_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CrashlyticsEx.toString', () {
    test('keeps the crashlytics prefix and default message key', () {
      expect(
        const UnknownCrashlyticsException().toString(),
        'crashlytics : unknown_crashlytics_exception_message_key',
      );
    });

    test('appends inner message and original error details', () {
      expect(
        UnknownCrashlyticsException(
          innerMessage: 'channel failure',
          innerError: StateError('offline'),
        ).toString(),
        'crashlytics : unknown_crashlytics_exception_message_key '
        '(channel failure | Bad state: offline)',
      );
    });

    test('uses a custom message key when provided', () {
      expect(
        const UnknownCrashlyticsException(messageKey: 'custom_key').toString(),
        'crashlytics : custom_key',
      );
    });
  });
}
