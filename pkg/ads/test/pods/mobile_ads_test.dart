import 'package:ads/implementations/google_mobile_ads_client.dart';
import 'package:ads/pods/mobile_ads.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shared/google_mobile_ads_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(GoogleMobileAdsTestHarness.install);

  tearDown(GoogleMobileAdsTestHarness.reset);

  test('mobileAdsPod exposes the live Google Mobile Ads client', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(mobileAdsPod), isA<GoogleMobileAdsClient>());
  });
}
