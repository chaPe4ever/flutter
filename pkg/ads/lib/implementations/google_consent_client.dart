import 'dart:async';

import 'package:ads/contracts/consent_client.dart';
import 'package:core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Loads a UMP consent form.
typedef LoadConsentForm =
    void Function(
      void Function(ConsentForm consentForm) onFormLoaded,
      void Function(FormError formError) onFormError,
    );

/// [ConsentClient] backed by the Google UMP SDK.
final class GoogleConsentClient implements ConsentClient {
  /// Creates a client that delegates to [consentInformation].
  GoogleConsentClient({
    ConsentInformation? consentInformation,
    LoadConsentForm? loadConsentForm,
  }) : _consentInformation = consentInformation ?? ConsentInformation.instance,
       _loadConsentForm = loadConsentForm ?? ConsentForm.loadConsentForm;

  final ConsentInformation _consentInformation;
  final LoadConsentForm _loadConsentForm;

  @override
  Future<bool> isConsentFormAvailable() =>
      _consentInformation.isConsentFormAvailable();

  @override
  Future<void> reset() => _consentInformation.reset();

  @override
  Future<bool> canRequestAds() => _consentInformation.canRequestAds();

  @override
  Future<ConsentStatus> getConsentStatus() =>
      _consentInformation.getConsentStatus();

  @override
  void requestConsentInfoUpdate(
    ConsentRequestParameters params,
    OnConsentInfoUpdateSuccessListener onSuccess,
    OnConsentInfoUpdateFailureListener onFailure,
  ) {
    _consentInformation.requestConsentInfoUpdate(
      params,
      onSuccess,
      onFailure,
    );
  }

  @override
  Future<void> loadAndShowConsentFormIfRequired(
    void Function(FormError? formError) onDismiss,
  ) {
    return ConsentForm.loadAndShowConsentFormIfRequired(onDismiss);
  }

  @override
  Future<void> loadAndShowConsentForm() async {
    Log.info('Loading consent form');

    final formCompleter = Completer<void>();

    _loadConsentForm(
      (ConsentForm consentForm) async {
        try {
          Log.info('Consent form loaded, showing to user');
          consentForm.show((formError) {
            if (!formCompleter.isCompleted) {
              if (formError != null) {
                Log.error('Consent form error: ${formError.message}');
                formCompleter.completeError(formError);
              } else {
                Log.info('Consent form closed');
                formCompleter.complete();
              }
            }
          });
        } on Exception catch (e) {
          Log.error('Error showing consent form: $e');
          if (!formCompleter.isCompleted) {
            formCompleter.completeError(e);
          }
        }
      },
      (formError) {
        Log.error('Consent form load error: ${formError.message}');
        if (!formCompleter.isCompleted) {
          formCompleter.completeError(formError);
        }
      },
    );

    try {
      await formCompleter.future;
      Log.info('Consent process completed');
    } on Object catch (e) {
      Log.error('Consent process error: $e');
    }
  }
}
