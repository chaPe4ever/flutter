import 'package:core/core.dart';
import 'package:in_app_rewiew/constants/in_app_review_constants.dart';
import 'package:in_app_rewiew/constants/trans_keys_constants.dart';

///
sealed class InAppReviewEx extends CoreException {
  const InAppReviewEx({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix = kInAppReviewPkgName,
  });
}

final class InAppReviewNotSupportedDeviceException extends InAppReviewEx {
  const InAppReviewNotSupportedDeviceException({
    super.messageKey = TransKeys.inAppReviewNotSupportedDeviceKey,
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

/// Exception thrown when the service is used before initialization
final class NotInitialisedInAppReviewException extends InAppReviewEx {
  const NotInitialisedInAppReviewException({
    super.messageKey = TransKeys.notInitialisedInAppReviewExceptionKey,
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}
