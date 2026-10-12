import 'package:analytics/exceptions/analytics_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnalyticsEx.toString', () {
    test('keeps the analytics prefix and default message keys', () {
      expect(
        UnknownAnalyticsException().toString(),
        'analytics : unknown_analytics_exception_message_key',
      );
      expect(
        WrongAnalyticsEventUsageException().toString(),
        'analytics : wrong_analytics_event_usage_exception_message_key',
      );
    });

    test('appends inner message and original error details', () {
      expect(
        UnknownAnalyticsException(
          innerMessage: 'channel failure',
          innerError: StateError('offline'),
        ).toString(),
        'analytics : unknown_analytics_exception_message_key '
        '(channel failure | Bad state: offline)',
      );
    });

    test('uses a custom message key when provided', () {
      expect(
        WrongAnalyticsEventUsageException(messageKey: 'custom_key').toString(),
        'analytics : custom_key',
      );
    });
  });
}
