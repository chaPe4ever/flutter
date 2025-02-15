import 'package:core/core.dart';
import 'package:crashlytics/constants/crashlytics_constants.dart';
import 'package:crashlytics/constants/trans_keys_constants.dart';

///
sealed class CrashlyticsEx extends CoreException {
  const CrashlyticsEx({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix = kCrashlyticsPkgName,
  });
}

///
final class UnknownCrashlyticsException extends CrashlyticsEx {
  ///
  const UnknownCrashlyticsException({
    super.messageKey = TransKeys.unknownCrashlyticsExceptionMessageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}
