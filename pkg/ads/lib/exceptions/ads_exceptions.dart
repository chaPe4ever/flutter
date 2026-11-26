import 'package:ads/constants/ads_constants.dart';
import 'package:ads/constants/trans_keys_constants.dart';
import 'package:core/core.dart';

///
sealed class AdsEx extends CoreException {
  const new({
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
  const new({
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
  const new({
    super.messageKey = TransKeys.interstitialAdLoadFailedKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}

final class AdsShowException extends AdsEx {
  ///
  const new({
    super.messageKey = TransKeys.interstitialAdLoadFailedKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}

final class AdsConsentFormNotAvailable extends AdsEx {
  ///
  const new({
    super.messageKey = TransKeys.adsConsentFormNotAvailableKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}

final class AdsBlockerException extends AdsEx {
  ///
  const new({
    super.messageKey = TransKeys.adsBlockerExceptionKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}

final class AdsNoFillException extends AdsEx {
  ///
  const new({
    super.messageKey = TransKeys.adsInventoryUnavailableKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}

final class AdsConsentChoicesOptedOutException extends AdsEx {
  ///
  const new({
    super.messageKey = TransKeys.adsConsentChoicesOptedOutKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}
