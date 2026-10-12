import 'package:ads/constants/trans_keys_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransKeys', () {
    test('exposes stable ads translation keys', () {
      expect(TransKeys.adsNotInitialisedKey, 'ads_not_initialised_key');
      expect(
        TransKeys.interstitialAdLoadFailedKey,
        'interstitial_ad_load_failed_key',
      );
      expect(
        TransKeys.interstitialAdShowFailedKey,
        'interstitial_ad_show_failed_key',
      );
      expect(
        TransKeys.adsConsentFormNotAvailableKey,
        'ads_consent_form_not_available_key',
      );
      expect(
        TransKeys.adsBlockerExceptionKey,
        'ads_blocker_exception_key',
      );
      expect(
        TransKeys.adsInventoryUnavailableKey,
        'ads_inventory_unavailable_key',
      );
      expect(
        TransKeys.adsConsentChoicesOptedOutKey,
        'ads_consent_choices_opted_out_key',
      );
    });
  });
}
