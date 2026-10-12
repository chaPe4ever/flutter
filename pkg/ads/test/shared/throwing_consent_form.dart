import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Consent form that throws synchronously when [show] is invoked.
class ThrowingConsentForm implements ConsentForm {
  ThrowingConsentForm([this.message = 'consent form show failed']);

  final String message;

  @override
  Future<void> dispose() async {}

  @override
  void show(OnConsentFormDismissedListener onConsentFormDismissedListener) {
    throw Exception(message);
  }
}
