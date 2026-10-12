import 'package:ads/implementations/google_consent_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../shared/google_mobile_ads_test_harness.dart';
import '../shared/throwing_consent_form.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GoogleMobileAdsTestHarness harness;

  setUp(() {
    harness = GoogleMobileAdsTestHarness.install();
  });

  tearDown(GoogleMobileAdsTestHarness.reset);

  test(
    'loadAndShowConsentForm completes when the form closes with an error',
    () async {
      final client = GoogleConsentClient();
      harness.consentFormShowError = FormError(
        errorCode: 1,
        message: 'dismissed with error',
      );

      await expectLater(client.loadAndShowConsentForm(), completes);
    },
  );

  test(
    'loadAndShowConsentForm continues when show fails on the platform',
    () async {
      final client = GoogleConsentClient();
      harness.failConsentFormShow = true;

      await expectLater(client.loadAndShowConsentForm(), completes);
    },
  );

  test(
    'loadAndShowConsentForm continues when show throws synchronously',
    () async {
      final client = GoogleConsentClient(
        loadConsentForm: (onFormLoaded, _) {
          onFormLoaded(ThrowingConsentForm());
        },
      );

      await expectLater(client.loadAndShowConsentForm(), completes);
    },
  );
}
