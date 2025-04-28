import 'package:ads/constants/ads_constants.dart';
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

final class AdsShowException extends AdsEx {
  ///
  const AdsShowException({
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
  const AdsConsentFormNotAvailable({
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
  const AdsBlockerException({
    super.messageKey = TransKeys.adsBlockerExceptionKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}

final class AdsInventoryUnavailableException extends AdsEx {
  ///
  const AdsInventoryUnavailableException({
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
  const AdsConsentChoicesOptedOutException({
    super.messageKey = TransKeys.adsConsentChoicesOptedOutKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}
