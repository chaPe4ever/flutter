import 'package:analytics/constants/trans_keys_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransKeys', () {
    test('maps exception message keys used by analytics', () {
      expect(
        TransKeys.unknownAnalyticsExceptionMessageKey,
        'unknown_analytics_exception_message_key',
      );
      expect(
        TransKeys.wrongAnalyticsEventUsageExceptionMessageKey,
        'wrong_analytics_event_usage_exception_message_key',
      );
    });
  });
}
