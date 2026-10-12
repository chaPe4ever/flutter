import 'dart:async';

import 'package:ads/contracts/interstitial_ad_loader.dart';
import 'package:ads/implementations/google_interstitial_ad_loader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Controllable interstitial loader for ads pod tests.
final class FakeInterstitialAdLoader implements InterstitialAdLoader {
  FakeInterstitialAdLoader({InterstitialAdLoader? delegate})
    : _delegate = delegate ?? GoogleInterstitialAdLoader();

  final InterstitialAdLoader _delegate;

  Completer<InterstitialAd>? pendingLoad;

  @override
  Future<InterstitialAd> load({
    required String adUnitId,
    required AdRequest request,
  }) {
    if (pendingLoad != null) {
      return pendingLoad!.future;
    }
    return _delegate.load(adUnitId: adUnitId, request: request);
  }

  void holdNextLoad() {
    pendingLoad = Completer<InterstitialAd>();
  }

  void completePendingLoadError(Object error) {
    pendingLoad?.completeError(error);
    pendingLoad = null;
  }
}
