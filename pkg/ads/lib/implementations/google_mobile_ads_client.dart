import 'package:ads/contracts/mobile_ads_client.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// [MobileAdsClient] backed by [MobileAds.instance].
final class GoogleMobileAdsClient implements MobileAdsClient {
  /// Creates a client that delegates to [mobileAds].
  GoogleMobileAdsClient(this.mobileAds);

  /// Underlying Google Mobile Ads SDK entry point.
  final MobileAds mobileAds;

  @override
  Future<void> initialize() => mobileAds.initialize().then((_) {});

  @override
  Future<void> updateRequestConfiguration(
    RequestConfiguration requestConfiguration,
  ) {
    return mobileAds.updateRequestConfiguration(requestConfiguration);
  }
}
