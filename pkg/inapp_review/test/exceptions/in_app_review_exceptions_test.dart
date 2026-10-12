import 'package:flutter_test/flutter_test.dart';
import 'package:inapp_review/constants/in_app_review_constants.dart';
import 'package:inapp_review/constants/trans_keys_constants.dart';
import 'package:inapp_review/exceptions/in_app_review_exceptions.dart';

void main() {
  group('InAppReviewEx', () {
    test('uses the in-app review package prefix by default', () {
      const exception = NotInitialisedInAppReviewException();

      expect(exception.prefix, kInAppReviewPkgName);
      expect(
        exception.toString(),
        '$kInAppReviewPkgName : '
        '${TransKeys.notInitialisedInAppReviewExceptionKey}',
      );
    });

    test('InAppReviewNotSupportedDeviceException exposes its message key', () {
      const exception = InAppReviewNotSupportedDeviceException();

      expect(
        exception.messageKey,
        TransKeys.inAppReviewNotSupportedDeviceKey,
      );
      expect(
        exception.toString(),
        '$kInAppReviewPkgName : ${TransKeys.inAppReviewNotSupportedDeviceKey}',
      );
    });

    test('forwards optional inner fields', () {
      final exception = NotInitialisedInAppReviewException(
        innerCode: 'init_missing',
        innerMessage: 'call init first',
        innerError: StateError('bad state'),
      );

      expect(exception.innerCode, 'init_missing');
      expect(exception.innerMessage, 'call init first');
      expect(exception.innerError, isA<StateError>());
    });
  });
}
