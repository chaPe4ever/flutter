import 'package:ads/contracts/mobile_ads_client.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FakeMobileAdsClient implements MobileAdsClient {
  FakeMobileAdsClient({this.failInitialize = false});

  bool failInitialize;
  int initializeCalls = 0;
  RequestConfiguration? lastRequestConfiguration;

  @override
  Future<void> initialize() async {
    initializeCalls++;
    if (failInitialize) {
      throw Exception('initialize failed');
    }
  }

  @override
  Future<void> updateRequestConfiguration(
    RequestConfiguration requestConfiguration,
  ) async {
    lastRequestConfiguration = requestConfiguration;
  }
}
