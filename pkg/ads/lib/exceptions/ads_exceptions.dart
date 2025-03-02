import 'package:ads/constants/crashlytics_constants.dart';
import 'package:ads/constants/trans_keys_constants.dart';
import 'package:core/core.dart';

///
sealed class AdsEx extends CoreException {
  const AdsEx({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix = kAdsPkgName,
  });
}

///
final class AdsInitException extends AdsEx {
  ///
  const AdsInitException({
    super.messageKey = TransKeys.adsNotInitialisedKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}

final class AdsLoadException extends AdsEx {
  ///
  const AdsLoadException({
    super.messageKey = TransKeys.interstitialAdLoadFailedKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}
