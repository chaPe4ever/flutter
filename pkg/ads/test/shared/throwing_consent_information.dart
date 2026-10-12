import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Consent information stub that throws when consent is requested.
final class ThrowingConsentInformation extends ConsentInformation {
  @override
  Future<bool> canRequestAds() async => true;

  @override
  Future<ConsentStatus> getConsentStatus() async => ConsentStatus.obtained;

  @override
  Future<bool> isConsentFormAvailable() async => false;

  @override
  Future<PrivacyOptionsRequirementStatus>
  getPrivacyOptionsRequirementStatus() async {
    return PrivacyOptionsRequirementStatus.notRequired;
  }

  @override
  void requestConsentInfoUpdate(
    ConsentRequestParameters params,
    OnConsentInfoUpdateSuccessListener successListener,
    OnConsentInfoUpdateFailureListener failureListener,
  ) {
    throw Exception('consent request blew up');
  }

  @override
  Future<void> reset() async {}
}
