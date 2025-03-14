// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:ads/exceptions/ads_exceptions.dart';
import 'package:ads/pods/mobile_ads.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'ads.g.dart';

@Riverpod(keepAlive: true)
class Ads extends _$Ads with NotifierMountedMixin {
  @override
  Future<void> build() async {
    ref.onDispose(setUnmounted);
    return;
  }

  Future<void> init({
    required String interstitialAdUnitId,
    AdRequest adRequest = const AdRequest(),
  }) async {
    if (!_isIntitialsed) {
      _isIntitialsed = true;
      _adRequest = adRequest;
      _interstitialAdUnitId = interstitialAdUnitId;
      final mobileAds = ref.read(mobileAdsPod);
      await mobileAds.initialize();
    }
  }

  static Completer<InterstitialAd>? _interstitialAdCompleter;
  late String _interstitialAdUnitId;
  late AdRequest _adRequest;
  static var _isIntitialsed = false;

  Future<void> showInterstitialAd({
    VoidCallback? onAdShowedFullScreenContent,
    VoidCallback? onAdDismissedFullScreenContent,
    void Function(CoreException error)? onAdFailedToShowFullScreenContent,
  }) async {
    if (_isIntitialsed == false) {
      throw const AdsInitException();
    }

    // Prevent multiple calls
    if (_interstitialAdCompleter != null &&
        _interstitialAdCompleter!.isCompleted) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard<void>(() async {
      final interstitialAd = await _loadInterstitialAd();
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          Log.info('Interstitial ad displayed');
          _interstitialAdCompleter = null;

          onAdShowedFullScreenContent?.call();
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          Log.info('Interstitial ad dismissed');
          ad.dispose();
          _interstitialAdCompleter = null;
          onAdDismissedFullScreenContent?.call();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          Log.error('Interstitial ad failed to show: $error');
          ad.dispose();
          _interstitialAdCompleter = null;
          final ex = AdsShowException(innerError: error);
          onAdFailedToShowFullScreenContent?.call(ex);
        },
      );

      // Show the ad
      await Future.microtask(() async => interstitialAd.show());
    });
  }

  Future<InterstitialAd> _loadInterstitialAd() async {
    _interstitialAdCompleter ??= Completer<InterstitialAd>();

    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: _adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          Log.info('Interstitial ad loaded successfully');
          _interstitialAdCompleter?.complete(ad..setImmersiveMode(true));
        },
        onAdFailedToLoad: (LoadAdError error) {
          Log.error('InterstitialAd failed to load: $error');
          _interstitialAdCompleter?.completeError(
            AdsLoadException(innerError: error),
          );
          _interstitialAdCompleter = null;
        },
      ),
    );

    return _interstitialAdCompleter!.future;
  }
}
