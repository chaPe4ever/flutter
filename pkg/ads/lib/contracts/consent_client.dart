import 'package:google_mobile_ads/google_mobile_ads.dart';

/// UMP consent surface used by the ads Riverpod notifier.
abstract class ConsentClient {
  /// Whether a consent form is available for the user.
  Future<bool> isConsentFormAvailable();

  /// Clears stored consent state.
  Future<void> reset();

  /// Whether ads may be requested under the current consent choice.
  Future<bool> canRequestAds();

  /// Current UMP consent status.
  Future<ConsentStatus> getConsentStatus();

  /// Refreshes consent metadata from the UMP SDK.
  void requestConsentInfoUpdate(
    ConsentRequestParameters params,
    OnConsentInfoUpdateSuccessListener onSuccess,
    OnConsentInfoUpdateFailureListener onFailure,
  );

  /// Presents the consent form when required by UMP policy.
  Future<void> loadAndShowConsentFormIfRequired(
    void Function(FormError? formError) onDismiss,
  );

  /// Loads and presents a consent form when one is offered.
  Future<void> loadAndShowConsentForm();
}
