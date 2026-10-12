import 'package:ads/implementations/google_mobile_ads_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../shared/google_mobile_ads_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(GoogleMobileAdsTestHarness.install);
  tearDown(GoogleMobileAdsTestHarness.reset);

  test('delegates initialize and request configuration to MobileAds', () async {
    final client = GoogleMobileAdsClient(MobileAds.instance);

    await client.initialize();
    await client.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['test-device']),
    );
  });
}
