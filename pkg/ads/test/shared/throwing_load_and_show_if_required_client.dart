import 'package:ads/contracts/consent_client.dart';
import 'package:ads/implementations/google_consent_client.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Consent client that throws from [loadAndShowConsentFormIfRequired].
final class ThrowingLoadAndShowIfRequiredClient implements ConsentClient {
  ThrowingLoadAndShowIfRequiredClient({ConsentClient? delegate})
    : _delegate = delegate ?? GoogleConsentClient();

  final ConsentClient _delegate;

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
    throw Exception('load and show failed');
  }

  @override
  Future<void> loadAndShowConsentForm() => _delegate.loadAndShowConsentForm();
}
