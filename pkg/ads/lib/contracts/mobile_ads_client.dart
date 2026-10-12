import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Minimal Mobile Ads surface used by the ads Riverpod notifier.
abstract class MobileAdsClient {
  /// Initializes the Google Mobile Ads SDK.
  Future<void> initialize();

  /// Applies [requestConfiguration] for future ad requests.
  Future<void> updateRequestConfiguration(
    RequestConfiguration requestConfiguration,
  );
}
