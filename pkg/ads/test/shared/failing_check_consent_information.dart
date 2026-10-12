import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Invokes the consent success callback, then fails during the follow-up check.
final class FailingCheckConsentInformation extends ConsentInformation {
  var _getConsentStatusCalls = 0;

  @override
  Future<bool> canRequestAds() async => true;

  @override
  Future<ConsentStatus> getConsentStatus() async {
    _getConsentStatusCalls++;
    if (_getConsentStatusCalls == 1) {
      throw StateError('consent status check failed');
    }
    return ConsentStatus.obtained;
  }

  @override
  Future<bool> isConsentFormAvailable() async => true;

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
    successListener();
  }

  @override
  Future<void> reset() async {}
}
