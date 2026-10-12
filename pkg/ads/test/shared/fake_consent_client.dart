import 'package:ads/contracts/consent_client.dart';
import 'package:ads/implementations/google_consent_client.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Consent client that delegates to [GoogleConsentClient] unless overridden.
final class FakeConsentClient implements ConsentClient {
  FakeConsentClient({
    ConsentClient? delegate,
    this.throwOnLoadAndShowConsentForm = false,
  }) : _delegate = delegate ?? GoogleConsentClient();

  final ConsentClient _delegate;
  final bool throwOnLoadAndShowConsentForm;

  @override
  Future<bool> isConsentFormAvailable() => _delegate.isConsentFormAvailable();

  @override
  Future<void> reset() => _delegate.reset();

  @override
  Future<bool> canRequestAds() => _delegate.canRequestAds();

  @override
  Future<ConsentStatus> getConsentStatus() => _delegate.getConsentStatus();

  @override
  void requestConsentInfoUpdate(
    ConsentRequestParameters params,
    OnConsentInfoUpdateSuccessListener onSuccess,
    OnConsentInfoUpdateFailureListener onFailure,
  ) {
    _delegate.requestConsentInfoUpdate(params, onSuccess, onFailure);
  }

  @override
  Future<void> loadAndShowConsentFormIfRequired(
    void Function(FormError? formError) onDismiss,
  ) {
    return _delegate.loadAndShowConsentFormIfRequired(onDismiss);
  }

  @override
  Future<void> loadAndShowConsentForm() {
    if (throwOnLoadAndShowConsentForm) {
      throw Exception('consent flow failure');
    }
    return _delegate.loadAndShowConsentForm();
  }
}
