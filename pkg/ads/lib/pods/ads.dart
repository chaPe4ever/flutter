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
    bool skipConsentForm = false,
  }) async {
    if (!_isInitialized) {
      Log.info('Initializing ad service with ID: $interstitialAdUnitId');
      _isInitialized = true;
      _adRequest = adRequest;
      _interstitialAdUnitId = interstitialAdUnitId;

      try {
        // First, request consent information
        if (!skipConsentForm) {
          await _requestConsentInfo();
        }

        // Then initialize the Mobile Ads SDK
        final mobileAds = ref.read(mobileAdsPod);
        await mobileAds.initialize();
        Log.info('Mobile ads initialized successfully');

        // Wait a moment before preloading to ensure initialization is complete
        await Future<void>.delayed(const Duration(milliseconds: 500));

        // Pre-load an ad after initialization
        await _preloadInterstitialAd();
      } catch (e) {
        Log.error('Error initializing ads: $e');
        // Don't rethrow, just log - this allows the app to continue functioning even if ads fail
      }
    }
  }

  Future<void> showInterstitialAd({
    VoidCallback? onAdShowedFullScreenContent,
    VoidCallback? onAdDismissedFullScreenContent,
    void Function(CoreException error)? onAdFailedToShowFullScreenContent,
    List<String> testDeviceIds = const [],
    bool skip = false,
  }) async {
    if (!_isInitialized) {
      throw const AdsInitException();
    }
    if (skip) {
      Log.info('Skipping ad display');
      onAdDismissedFullScreenContent?.call();
      return;
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

  /// Resets the user's consent choice and shows the consent form again
  /// Can be called from app settings to let users update their choice
  Future<void> resetConsent() async {
    try {
      Log.info('Resetting user consent');

      // Check if form is available
      final isFormAvailable =
          await ConsentInformation.instance.isConsentFormAvailable();
      if (!isFormAvailable) {
        Log.info('Consent form is not available, cannot reset consent');
        return;
      }

      // Reset the consent info
      await ConsentInformation.instance.reset();
      Log.info('Consent reset successfully');

      // Request consent again
      await _requestConsentInfo();
    } catch (e) {
      Log.error('Error resetting consent: $e');
    }
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

    // Make sure ad unit ID and ad request are not null
    if (_interstitialAdUnitId == null || _adRequest == null) {
      Log.error('Ad unit ID or AdRequest is null');
      _interstitialAdCompleter?.completeError(
        const AdsInitException(innerMessage: 'Ad unit ID or AdRequest is null'),
      );
      _interstitialAdCompleter = null;
      throw const AdsInitException(
        innerMessage: 'Ad unit ID or AdRequest is null',
      );
    }

    try {
      // Get consent status to determine non-personalized ads
      final consentStatus =
          await ConsentInformation.instance.getConsentStatus();
      final useNonPersonalizedAds = consentStatus != ConsentStatus.obtained;

      // Create an ad request with consent parameters
      final request = AdRequest(
        nonPersonalizedAds: useNonPersonalizedAds,
        keywords: _adRequest?.keywords,
        contentUrl: _adRequest?.contentUrl,
        neighboringContentUrls: _adRequest?.neighboringContentUrls,
        httpTimeoutMillis: _adRequest?.httpTimeoutMillis,
        mediationExtras: _adRequest?.mediationExtras,
        extras: _adRequest?.extras,
      );
      await InterstitialAd.load(
        adUnitId: _interstitialAdUnitId!,
        request: request,
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

            final exception = AdsLoadException(innerError: error);
            if (_interstitialAdCompleter?.isCompleted == false) {
              _interstitialAdCompleter?.completeError(exception);
            }
            _interstitialAdCompleter = null;
          },
        ),
      );
    } catch (e) {
      Log.error('Exception while loading ad: $e');
      if (_interstitialAdCompleter?.isCompleted == false) {
        _interstitialAdCompleter?.completeError(e);
      }
      _interstitialAdCompleter = null;
      rethrow;
    }

    try {
      return await _interstitialAdCompleter!.future;
    } catch (e) {
      Log.error('Error waiting for ad to load: $e');
      _interstitialAdCompleter = null;
      rethrow;
    }
  }

  Future<void> _loadAndShowConsentForm() async {
    try {
      Log.info('Loading consent form');

      final formCompleter = Completer<void>();

      ConsentForm.loadConsentForm(
        (ConsentForm consentForm) async {
          try {
            Log.info('Consent form loaded, showing to user');
            consentForm.show((formError) {
              if (!formCompleter.isCompleted) {
                if (formError != null) {
                  Log.error('Consent form error: ${formError.message}');
                  formCompleter.completeError(formError);
                } else {
                  Log.info('Consent form closed');
                  formCompleter.complete();
                }
              }
            });
          } catch (e) {
            Log.error('Error showing consent form: $e');
            if (!formCompleter.isCompleted) {
              formCompleter.completeError(e);
            }
          }
        },
        (formError) {
          Log.error('Consent form load error: ${formError.message}');
          if (!formCompleter.isCompleted) {
            formCompleter.completeError(formError);
          }
        },
      );

      // Wait for the form to be closed
      try {
        await formCompleter.future;
        Log.info('Consent process completed');
      } catch (e) {
        Log.error('Consent process error: $e');
        // Continue with initialization even if consent fails
      }
    } catch (e) {
      Log.error('Error in consent flow: $e');
      // Continue with initialization even if consent fails
    }
  }

  Future<void> _checkAndShowConsentForm() async {
    try {
      final status = await ConsentInformation.instance.getConsentStatus();
      final required =
          await ConsentInformation.instance.isConsentFormAvailable();

      Log.info('Consent status: $status, Form required: $required');

      if (required) {
        await _loadAndShowConsentForm();
      }
    } catch (e) {
      Log.error('Error checking consent status: $e');
    }
  }

  Future<void> _requestConsentInfo() async {
    try {
      Log.info('Requesting consent information');

      // For testing, you can use a test device and test in EEA
      // final params = ConsentRequestParameters(
      //   tagForUnderAgeOfConsent: false,
      //   testIdentifiers: ['TEST-DEVICE-HASHED-ID'], // Test device ID
      //   consentDebugSettings: ConsentDebugSettings(
      //     debugGeography: DebugGeography.debugGeographyEEA,
      //     testIdentifiers: ['TEST-DEVICE-HASHED-ID'],
      //   ),
      // );

      // For production use:
      final params = ConsentRequestParameters(tagForUnderAgeOfConsent: false);

      // Create a completer to wait for the async callback
      final completer = Completer<void>();

      // Request latest consent info
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () {
          // Success callback
          Log.info('Consent info updated successfully');
          _checkAndShowConsentForm()
              .then((_) => completer.complete())
              .catchError((Object e) {
                Log.error('Error in consent flow: $e');
                completer
                    .complete(); // Complete anyway to continue initialization
              });
        },
        (FormError error) {
          // Error callback
          Log.error('Consent info update failed: ${error.message}');
          completer.complete(); // Complete to continue initialization
        },
      );

      // Wait for the consent flow to complete before continuing
      await completer.future;
    } catch (e) {
      Log.error('Error requesting consent: $e');
      // Continue with initialization even if consent fails
    }
  }

  Future<void> _preloadInterstitialAd() async {
    try {
      if (_isInitialized && _interstitialAdCompleter == null) {
        Log.info('Preloading interstitial ad');
        await _loadInterstitialAd();
      }
    } catch (e) {
      Log.error('Failed to preload interstitial ad: $e');
      // Don't rethrow, just log the error
    }
  }
}
