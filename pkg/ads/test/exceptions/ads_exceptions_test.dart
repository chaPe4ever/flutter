import 'package:ads/constants/ads_constants.dart';
import 'package:ads/constants/trans_keys_constants.dart';
import 'package:ads/exceptions/ads_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdsEx.toString', () {
    test('prefixes messages with the ads package name by default', () {
      expect(
        const AdsInitException().toString(),
        'ads : ${TransKeys.adsNotInitialisedKey}',
      );
    });

    test('maps load failures to the interstitial load key', () {
      expect(
        const AdsLoadException().toString(),
        'ads : ${TransKeys.interstitialAdLoadFailedKey}',
      );
    });

    test('maps show failures to the interstitial load key', () {
      expect(
        const AdsShowException().toString(),
        'ads : ${TransKeys.interstitialAdLoadFailedKey}',
      );
    });

    test('maps consent form unavailability', () {
      expect(
        const AdsConsentFormNotAvailable().toString(),
        'ads : ${TransKeys.adsConsentFormNotAvailableKey}',
      );
    });

    test('maps ad blocker failures', () {
      expect(
        const AdsBlockerException().toString(),
        'ads : ${TransKeys.adsBlockerExceptionKey}',
      );
    });

    test('maps inventory no-fill failures', () {
      expect(
        const AdsNoFillException().toString(),
        'ads : ${TransKeys.adsInventoryUnavailableKey}',
      );
    });

    test('maps consent opt-out failures', () {
      expect(
        const AdsConsentChoicesOptedOutException().toString(),
        'ads : ${TransKeys.adsConsentChoicesOptedOutKey}',
      );
    });

    test('appends inner details when present', () {
      expect(
        AdsLoadException(
          innerMessage: 'timeout',
          innerError: StateError('offline'),
        ).toString(),
        'ads : ${TransKeys.interstitialAdLoadFailedKey} '
        '(timeout | Bad state: offline)',
      );
    });

    test('uses a custom prefix when provided', () {
      expect(
        const AdsInitException(prefix: 'custom').toString(),
        'custom : ${TransKeys.adsNotInitialisedKey}',
      );
    });

    test('keeps the default ads prefix constant', () {
      expect(kAdsPkgName, 'ads');
    });
  });
}
