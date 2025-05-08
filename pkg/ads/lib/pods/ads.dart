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

  /// Shows an interstitial ad.
  /// If the ad is not ready, it will attempt to load a new one.
  /// If the ad fails to load, it will throw an exception.
  /// The ad will be skipped if the `skip` parameter is set to true.
  /// Callbacks are provided for ad events:
  /// - `onAdShowedFullScreenContent`: Called when the ad is shown.
  /// - `onAdDismissedFullScreenContent`: Called when the ad is dismissed.
  /// - `onAdFailedToShowFullScreenContent`: Called when the ad fails to show.
  /// The `testDeviceIds` parameter allows you to specify test device IDs for testing purposes.
  /// The `skip` parameter allows you to skip showing the ad for testing or other purposes.
  /// Error codes:
  /// General Errors (0-19)
  /// 0: kGADErrorInvalidRequest - The ad request is invalid (wrong parameters or formatting)
  /// 1: kGADErrorNoFill - No ad available to be served (inventory unavailable)
  /// 2: kGADErrorNetworkError - Network connectivity or server communication error
  /// 3: kGADErrorServerError - Ad server experienced an error while processing the request
  /// 4: kGADErrorOSVersionTooLow - The operating system version is lower than required
  /// 5: kGADErrorTimeout - The ad request timed out
  /// 6: kGADErrorInterstitialAlreadyUsed - The interstitial object was already used (cannot be reused)
  /// 7: kGADErrorMediationDataError - Error in the mediation response data
  /// 8: kGADErrorMediationAdapterError - Adapter failed during mediation flow
  /// 9: kGADErrorMediationNoFill - No fill from mediation adapter
  /// 10: kGADErrorMediationInvalidAdSize - Invalid ad size used in mediation
  /// 11: kGADErrorInternalError - Internal SDK error
  /// 12: kGADErrorInvalidArgument - Invalid argument passed to a method
  /// 13: kGADErrorReceivedInvalidResponse - Ad server returned an invalid response
  /// 14: kGADErrorRewardedAdAlreadyUsed - Rewarded ad was already used (cannot be reused)
  /// Adaptive Banner Errors (20-29)
  /// 20: kGADErrorAdaptiveBannerSizeError - Invalid or unsupported adaptive banner size
  /// GDPR and Consent Errors (30-39)
  /// 30: kGADErrorNotInitialized - SDK not initialized (call startWithCompletionHandler first)
  /// 31: kGADErrorConsentInfoUpdateFailure - Failed to update user consent information
  /// 32: kGADErrorConsentInfoUpdateNotRequired - Consent information update not required
  /// App Open Ad Errors (40-49)
  /// 40: kGADErrorAppOpenAdAlreadyUsed - App open ad was already used (cannot be reused)
  /// Failed to Receive Ad Errors (50-59)
  /// 50: kGADErrorAdRequestError - Error while making the ad request
  /// 51: kGADErrorAdLoadAlreadyInProgress - Ad is already being loaded
  /// Native Ad Errors (60-69)
  /// 60: kGADErrorNativeAdResponseValidationFailure - Native ad response validation failed
  /// 61: kGADErrorNativeAdNoAssetsToLoad - No native ad assets to load
  /// MARK: Ad Storage Errors (70-79)
  /// 70: kGADErrorStorageError - Error accessing or modifying ad storage
  /// Mediation Adapter Configuration Errors (80-89)
  /// 80: kGADErrorMediationAdapterClassRequiredServerParameters - Adapter requires server parameters but none provided
  /// 81: kGADErrorInvalidMediationCredentials - Invalid credentials provided for mediation
  /// Unknown Errors
  /// -1: kGADErrorUnknown - Unknown or unspecified error occurred
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
        final error = e.toCoreException(
          customEx: AdsLoadException(innerError: e),
        );
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
          CoreException? exception;

          if (error.code == 1) {
            exception = AdsNoFillException(
              innerError: error,
              innerCode: error.code.toString(),
              innerMessage: error.message,
            );
          } else if (error.code == 2) {
            exception = AdsBlockerException(
              innerError: error,
              innerCode: error.code.toString(),
              innerMessage: error.message,
            );
          } else if (error.code == 3) {
            exception = AdsConsentChoicesOptedOutException(
              innerError: error,
              innerCode: error.code.toString(),
              innerMessage: error.message,
            );
          } else {
            exception = AdsShowException(
              innerError: error,
              innerCode: error.code.toString(),
              innerMessage: error.message,
            );
          }

          onAdFailedToShowFullScreenContent?.call(exception);

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

  Future<bool> get isConsetnFormAvailable =>
      ConsentInformation.instance.isConsentFormAvailable();

  /// Resets the user's consent choice and shows the consent form again
  /// Can be called from app settings to let users update their choice
  Future<void> resetConsent() async {
    Log.info('Resetting user consent');

    // Check if form is available
    final isFormAvailable =
        await ConsentInformation.instance.isConsentFormAvailable();

    if (!isFormAvailable) {
      Log.info('Consent form is not available, cannot reset consent');
      throw const AdsConsentFormNotAvailable();
    }

    // Reset the consent info
    await ConsentInformation.instance.reset();
    Log.info('Consent reset successfully');

    // Request consent again
    await _requestConsentInfo();
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
            CoreException? exception;
            if (error.code == 1) {
              exception = AdsNoFillException(
                innerError: error,
                innerCode: error.code.toString(),
                innerMessage: error.message,
              );
            } else if (error.code == 2) {
              exception = AdsBlockerException(
                innerError: error,
                innerCode: error.code.toString(),
                innerMessage: error.message,
              );
            } else if (error.code == 3) {
              exception = AdsConsentChoicesOptedOutException(
                innerError: error,
                innerCode: error.code.toString(),
                innerMessage: error.message,
              );
            } else {
              exception = AdsLoadException(
                innerError: error,
                innerCode: error.code.toString(),
                innerMessage: error.message,
              );
            }

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
      if (_interstitialAdCompleter != null) {
        return _interstitialAdCompleter!.future;
      } else {
        throw const AdsLoadException(
          innerMessage: 'Interstitial ad load failed',
        );
      }
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

      if (required && status == ConsentStatus.required) {
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
