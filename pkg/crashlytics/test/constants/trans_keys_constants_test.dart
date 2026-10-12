import 'package:crashlytics/constants/trans_keys_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransKeys', () {
    test('maps exception message keys used by crashlytics', () {
      expect(
        TransKeys.unknownCrashlyticsExceptionMessageKey,
        'unknown_crashlytics_exception_message_key',
      );
    });
  });
}
