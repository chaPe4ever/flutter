import 'dart:async';

import 'package:ads/contracts/consent_client.dart';
import 'package:ads/implementations/google_consent_client.dart';
import 'package:core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'throwing_consent_form.dart';

/// Runs the consent form flow but uses [ThrowingConsentForm] when showing.
final class ThrowingShowConsentClient implements ConsentClient {
  ThrowingShowConsentClient({ConsentClient? delegate})
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
    return _delegate.loadAndShowConsentFormIfRequired(onDismiss);
  }

  @override
  Future<void> loadAndShowConsentForm() async {
    Log.info('Loading consent form');

    final formCompleter = Completer<void>();

    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        try {
          Log.info('Consent form loaded, showing to user');
          ThrowingConsentForm().show((formError) {
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
