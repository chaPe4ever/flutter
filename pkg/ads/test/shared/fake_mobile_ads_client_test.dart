import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'fake_mobile_ads_client.dart';

void main() {
  group('FakeMobileAdsClient', () {
    test('tracks initialize and request configuration calls', () async {
      final client = FakeMobileAdsClient();

      await client.initialize();
      await client.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: ['a']),
      );

      expect(client.initializeCalls, 1);
      expect(client.lastRequestConfiguration?.testDeviceIds, ['a']);
    });

    test('throws when configured to fail initialization', () async {
      final client = FakeMobileAdsClient(failInitialize: true);

      await expectLater(client.initialize(), throwsA(isException));
    });
  });
}
