import 'dart:async';

import 'package:ads/exceptions/ads_exceptions.dart';
import 'package:ads/pods/mobile_ads.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'ads.g.dart';

@Riverpod(keepAlive: true)
class Ads extends _$Ads with NotifierMountedMixin {
  bool _isInitialized = false;
  String? _interstitialAdUnitId;
  AdRequest? _adRequest;
  Completer<InterstitialAd>? _interstitialAdCompleter;
  InterstitialAd? _cachedInterstitialAd;
  Timer? _adLoadRetryTimer;

  @override
  Future<void> build() async {
    ref.onDispose(() {
      setUnmounted();
      _disposeResources();
    });
    return;
  }

  void _disposeResources() {
    _adLoadRetryTimer?.cancel();
    _cachedInterstitialAd?.dispose();
    _cachedInterstitialAd = null;
    _interstitialAdCompleter = null;
  }

  Future<void> init({
    required String interstitialAdUnitId,
    AdRequest adRequest = const AdRequest(),
  }) async {
    if (!_isInitialized) {
      _isInitialized = true;
      _adRequest = adRequest;
      _interstitialAdUnitId = interstitialAdUnitId;
      final mobileAds = ref.read(mobileAdsPod);
      await mobileAds.initialize();

      // Pre-load an ad after initialization
      await _preloadInterstitialAd();
    }
  }

  Future<void> _preloadInterstitialAd() async {
    try {
      if (_isInitialized && _interstitialAdCompleter == null) {
        await _loadInterstitialAd();
      }
    } catch (e) {
      Log.error('Failed to preload interstitial ad: $e');
    }
  }

  Future<void> showInterstitialAd({
    VoidCallback? onAdShowedFullScreenContent,
    VoidCallback? onAdDismissedFullScreenContent,
    void Function(CoreException error)? onAdFailedToShowFullScreenContent,
    List<String> testDeviceIds = const [],
  }) async {
    if (!_isInitialized) {
      throw const AdsInitException();
    }

    if (testDeviceIds.isNotEmpty) {
      await ref
          .read(mobileAdsPod)
          .updateRequestConfiguration(
            RequestConfiguration(testDeviceIds: testDeviceIds),
          );
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard<void>(() async {
      InterstitialAd? interstitialAd;

      try {
        interstitialAd = await _loadInterstitialAd();
      } catch (e) {
        final error = e is CoreException ? e : AdsLoadException(innerError: e);
        onAdFailedToShowFullScreenContent?.call(error);
        throw error;
      }

      // Set up the callback before showing the ad
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          Log.info('Interstitial ad displayed');
          onAdShowedFullScreenContent?.call();

          // Cancel existing timer if any
          _adLoadRetryTimer?.cancel();

          // Start pre-loading the next ad
          _adLoadRetryTimer = Timer(
            const Duration(milliseconds: 500),
            _preloadInterstitialAd,
          );
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          Log.info('Interstitial ad dismissed');
          ad.dispose();
          _cachedInterstitialAd = null;
          onAdDismissedFullScreenContent?.call();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          Log.error('Interstitial ad failed to show: $error');
          ad.dispose();
          _cachedInterstitialAd = null;

          final ex = AdsShowException(
            innerError: error,
            innerCode: error.code.toString(),
            innerMessage: error.message,
          );
          onAdFailedToShowFullScreenContent?.call(ex);

          // Cancel existing timer if any
          _adLoadRetryTimer?.cancel();

          // Try to preload a new ad
          _adLoadRetryTimer = Timer(
            const Duration(seconds: 5),
            _preloadInterstitialAd,
          );
        },
      );

      // Show the ad
      await interstitialAd.show();
    });
  }

  Future<InterstitialAd> _loadInterstitialAd() async {
    // If we already have a cached ad, return it
    if (_cachedInterstitialAd != null) {
      final ad = _cachedInterstitialAd!;
      _cachedInterstitialAd = null;
      return ad;
    }

    // If we're already loading an ad, return that future
    if (_interstitialAdCompleter != null) {
      return _interstitialAdCompleter!.future;
    }

    // Start loading a new ad
    _interstitialAdCompleter = Completer<InterstitialAd>();

    if (_interstitialAdUnitId == null || _adRequest == null) {
      _interstitialAdCompleter?.completeError(
        const AdsInitException(innerMessage: 'Ad unit ID or AdRequest is null'),
      );
      _interstitialAdCompleter = null;
      throw const AdsInitException(
        innerMessage: 'Ad unit ID or AdRequest is null',
      );
    }

    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId!,
      request: _adRequest!,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          Log.info('Interstitial ad loaded successfully');
          ad.setImmersiveMode(true);

          if (_interstitialAdCompleter?.isCompleted == false) {
            _interstitialAdCompleter?.complete(ad);
          } else {
            // If for some reason the completer is no longer valid,
            // cache the ad for next use
            _cachedInterstitialAd = ad;
          }
          _interstitialAdCompleter = null;
        },
        onAdFailedToLoad: (LoadAdError error) {
          Log.error('InterstitialAd failed to load: $error');

          final exception = AdsLoadException(
            innerError: error,
            innerCode: error.code.toString(),
            innerMessage: error.message,
          );
          if (_interstitialAdCompleter?.isCompleted == false) {
            _interstitialAdCompleter?.completeError(exception);
          }
          _interstitialAdCompleter = null;

          // Cancel existing timer if any
          _adLoadRetryTimer?.cancel();

          // Schedule a retry after some delay
          _adLoadRetryTimer = Timer(
            const Duration(seconds: 30),
            _preloadInterstitialAd,
          );
        },
      ),
    );

    try {
      return await _interstitialAdCompleter!.future;
    } catch (e) {
      Log.error('Error waiting for ad to load: $e');
      _interstitialAdCompleter = null;
      rethrow;
    }
  }
}
