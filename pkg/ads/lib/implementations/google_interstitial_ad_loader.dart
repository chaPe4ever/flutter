import 'dart:async';

import 'package:ads/contracts/interstitial_ad_loader.dart';
import 'package:ads/exceptions/ads_exceptions.dart';
import 'package:core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// [InterstitialAdLoader] backed by [InterstitialAd.load].
final class GoogleInterstitialAdLoader implements InterstitialAdLoader {
  @override
  Future<InterstitialAd> load({
    required String adUnitId,
    required AdRequest request,
  }) async {
    final completer = Completer<InterstitialAd>();

    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            Log.info('Interstitial ad loaded successfully');
            ad.setImmersiveMode(true);
            if (!completer.isCompleted) {
              completer.complete(ad);
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            Log.error('InterstitialAd failed to load: $error');
            if (!completer.isCompleted) {
              completer.completeError(_mapLoadError(error));
            }
          },
        ),
      );
    } on Exception catch (e) {
      Log.error('Exception while loading ad: $e');
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    }

    return completer.future;
  }

  CoreException _mapLoadError(LoadAdError error) {
    if (error.code == 1 ||
        (error.code == 3 && error.message.toLowerCase().contains('no fill'))) {
      return AdsNoFillException(
        innerError: error,
        innerCode: error.code.toString(),
        innerMessage: error.message,
      );
    }
    if (error.code == 2) {
      return AdsBlockerException(
        innerError: error,
        innerCode: error.code.toString(),
        innerMessage: error.message,
      );
    }
    if (error.code == 3) {
      return AdsConsentChoicesOptedOutException(
        innerError: error,
        innerCode: error.code.toString(),
        innerMessage: error.message,
      );
    }
    return AdsLoadException(
      innerError: error,
      innerCode: error.code.toString(),
      innerMessage: error.message,
    );
  }
}
