import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Loads interstitial ads for the ads Riverpod notifier.
abstract class InterstitialAdLoader {
  /// Loads an interstitial for [adUnitId] using [request].
  Future<InterstitialAd> load({
    required String adUnitId,
    required AdRequest request,
  });
}
