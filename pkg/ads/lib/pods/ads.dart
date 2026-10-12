import 'dart:async';

import 'package:ads/contracts/consent_client.dart';
import 'package:ads/contracts/interstitial_ad_loader.dart';
import 'package:ads/exceptions/ads_exceptions.dart';
import 'package:ads/pods/consent.dart';
import 'package:ads/pods/interstitial_ad_load_config.dart';
import 'package:ads/pods/interstitial_ad_loader.dart';
import 'package:ads/pods/mobile_ads.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'ads.g.dart';

@Riverpod(keepAlive: true)
class Ads extends _$Ads with NotifierMountedMixin {
  bool _isInitialized = false;
  bool _skipConsentForm = false;
  Future<InterstitialAd>? _inFlightInterstitialLoad;
  InterstitialAd? _cachedInterstitialAd;
  Timer? _adLoadRetryTimer;

  ConsentClient get _consent => ref.read(consentClientPod);

  InterstitialAdLoader get _interstitialLoader =>
      ref.read(interstitialAdLoaderPod);

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
    _inFlightInterstitialLoad = null;
  }

  Future<void> init({
    required String interstitialAdUnitId,
    AdRequest adRequest = const AdRequest(),
    bool skipConsentForm = false,
  }) async {
    if (!_isInitialized) {
      Log.info('Initializing ad service with ID: $interstitialAdUnitId');
      _isInitialized = true;
      _skipConsentForm = skipConsentForm;
      ref
          .read(interstitialAdLoadConfigPod.notifier)
          .configure(
            adUnitId: interstitialAdUnitId,
            adRequest: adRequest,
          );

      try {
        // First, request consent information
        if (!_skipConsentForm) {
          await _requestConsentInfo();
        } else {
          Log.info('Skipping UMP consent form (skipConsentForm=true)');
        }

        // Then initialize the Mobile Ads SDK
        final mobileAds = ref.read(mobileAdsPod);
        await mobileAds.initialize();
        Log.info('Mobile ads initialized successfully');

        // Pre-load an ad after initialization
        unawaited(_preloadInterstitialAd());
      } on Exception catch (e) {
        Log.error('Error initializing ads: $e');
        // Don't rethrow, just log - this allows the app to continue
        // functioning even if ads fail
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
  /// The `testDeviceIds` parameter allows you to specify test device IDs
  /// for testing purposes.
  /// The `skip` parameter allows you to skip showing the ad for testing or
  /// other purposes.
  /// Error codes:
  /// General Errors (0-19)
  /// 0: kGADErrorInvalidRequest - The ad request is invalid (wrong
  /// parameters or formatting)
  /// 1: kGADErrorNoFill - No ad available to be served (inventory
  /// unavailable)
  /// 2: kGADErrorNetworkError - Network connectivity or server
  /// communication error
  /// 3: kGADErrorServerError - Ad server experienced an error while
  /// processing the request
  /// 4: kGADErrorOSVersionTooLow - The operating system version is lower
  /// than required
  /// 5: kGADErrorTimeout - The ad request timed out
  /// 6: kGADErrorInterstitialAlreadyUsed - The interstitial object was
  /// already used (cannot be reused)
  /// 7: kGADErrorMediationDataError - Error in the mediation response data
  /// 8: kGADErrorMediationAdapterError - Adapter failed during mediation
  /// flow
  /// 9: kGADErrorMediationNoFill - No fill from mediation adapter
  /// 10: kGADErrorMediationInvalidAdSize - Invalid ad size used in
  /// mediation
  /// 11: kGADErrorInternalError - Internal SDK error
  /// 12: kGADErrorInvalidArgument - Invalid argument passed to a method
  /// 13: kGADErrorReceivedInvalidResponse - Ad server returned an invalid
  /// response
  /// 14: kGADErrorRewardedAdAlreadyUsed - Rewarded ad was already used
  /// (cannot be reused)
  /// Adaptive Banner Errors (20-29)
  /// 20: kGADErrorAdaptiveBannerSizeError - Invalid or unsupported adaptive
  /// banner size
  /// GDPR and Consent Errors (30-39)
  /// 30: kGADErrorNotInitialized - SDK not initialized (call
  /// startWithCompletionHandler first)
  /// 31: kGADErrorConsentInfoUpdateFailure - Failed to update user consent
  /// information
  /// 32: kGADErrorConsentInfoUpdateNotRequired - Consent information update
  /// not required
  /// App Open Ad Errors (40-49)
  /// 40: kGADErrorAppOpenAdAlreadyUsed - App open ad was already used
  /// (cannot be reused)
  /// Failed to Receive Ad Errors (50-59)
  /// 50: kGADErrorAdRequestError - Error while making the ad request
  /// 51: kGADErrorAdLoadAlreadyInProgress - Ad is already being loaded
  /// Native Ad Errors (60-69)
  /// 60: kGADErrorNativeAdResponseValidationFailure - Native ad response
  /// validation failed
  /// 61: kGADErrorNativeAdNoAssetsToLoad - No native ad assets to load
  /// MARK: Ad Storage Errors (70-79)
  /// 70: kGADErrorStorageError - Error accessing or modifying ad storage
  /// Mediation Adapter Configuration Errors (80-89)
  /// 80: kGADErrorMediationAdapterClassRequiredServerParameters -
  /// Adapter requires server parameters but none provided
  /// 81: kGADErrorInvalidMediationCredentials - Invalid credentials
  /// provided for mediation
  /// Unknown Errors
  /// -1: kGADErrorUnknown - Unknown or unspecified error occurred
  Future<void> showInterstitialAd({
    VoidCallback? onAdShowedFullScreenContent,
    VoidCallback? onAdDismissedFullScreenContent,
    void Function(CoreException error)? onAdFailedToShowFullScreenContent,
    List<String> testDeviceIds = const [],
    bool skip = false,
  }) async {
    if (skip || kIsWeb) {
      Log.info('Skipping ad display');
      onAdDismissedFullScreenContent?.call();
      return;
    }
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
      // UMP may require a form after paywall (or when consent expired). Show it
      // before load so we never treat a consent-gated miss as inventory no-fill
      // and proceed without an interstitial.
      await _ensureConsentAllowsAdsOrThrow();

      InterstitialAd? interstitialAd;

      try {
        interstitialAd = await _loadInterstitialAd();
      } on Exception catch (e) {
        var error = e.toCoreException(
          customEx: AdsLoadException(innerError: e),
        );
        // Consent-gated load failures are often reported as no-fill (code 1/3).
        if (error is AdsNoFillException && !_skipConsentForm) {
          final canRequest = await _consent.canRequestAds();
          if (!canRequest) {
            error = AdsConsentChoicesOptedOutException(
              innerError: e,
              innerMessage: error.innerMessage,
              innerCode: error.innerCode,
            );
          }
        }
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

          if (error.code == 1 ||
              (error.code == 3 &&
                  error.message.toLowerCase().contains('no fill'))) {
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

  Future<bool> get isConsetnFormAvailable => _consent.isConsentFormAvailable();

  /// Resets the user's consent choice and shows the consent form again when
  /// the UMP SDK offers one (e.g. EEA). Elsewhere the form is often reported
  /// as unavailable even though clearing storage still makes sense, so we
  /// always call reset first and only then optionally run the consent UI flow.
  Future<void> resetConsent() async {
    Log.info('Resetting user consent');

    await _consent.reset();
    Log.info('Consent reset applied in storage');

    if (_skipConsentForm) {
      Log.info('Skipping UMP consent form after reset (skipConsentForm=true)');
      return;
    }

    final isFormAvailable = await _consent.isConsentFormAvailable();

    if (isFormAvailable) {
      await _requestConsentInfo();
    } else {
      Log.info(
        'Consent form not available after reset (e.g. non-EEA); '
        'storage reset is complete',
      );
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
    final inFlight = _inFlightInterstitialLoad;
    if (inFlight != null) {
      return inFlight;
    }

    final loadConfig = ref.read(interstitialAdLoadConfigPod);
    final interstitialAdUnitId = loadConfig.adUnitId;
    final adRequest = loadConfig.adRequest;

    // Make sure ad unit ID and ad request are not null
    if (interstitialAdUnitId == null || adRequest == null) {
      Log.error('Ad unit ID or AdRequest is null');
      throw const AdsInitException(
        innerMessage: 'Ad unit ID or AdRequest is null',
      );
    }

    final loadFuture = _startInterstitialLoad(
      interstitialAdUnitId: interstitialAdUnitId,
      adRequest: adRequest,
    );
    _inFlightInterstitialLoad = loadFuture;

    try {
      return await loadFuture;
    } on Exception catch (e) {
      Log.error('Error waiting for ad to load: $e');
      rethrow;
    } finally {
      if (identical(_inFlightInterstitialLoad, loadFuture)) {
        _inFlightInterstitialLoad = null;
      }
    }
  }

  Future<InterstitialAd> _startInterstitialLoad({
    required String interstitialAdUnitId,
    required AdRequest adRequest,
  }) async {
    try {
      final consentStatus = await _consent.getConsentStatus();
      final useNonPersonalizedAds = consentStatus != ConsentStatus.obtained;

      final request = AdRequest(
        nonPersonalizedAds: useNonPersonalizedAds,
        keywords: adRequest.keywords,
        contentUrl: adRequest.contentUrl,
        neighboringContentUrls: adRequest.neighboringContentUrls,
        httpTimeoutMillis: adRequest.httpTimeoutMillis,
        mediationExtras: adRequest.mediationExtras,
        extras: adRequest.extras,
      );

      return await _interstitialLoader.load(
        adUnitId: interstitialAdUnitId,
        request: request,
      );
    } on Exception catch (e) {
      Log.error('Exception while loading ad: $e');
      rethrow;
    }
  }

  /// Shows the UMP form when required, then fails if ads still cannot be
  /// requested (user opted out / consent not obtained).
  Future<void> _ensureConsentAllowsAdsOrThrow() async {
    if (_skipConsentForm) {
      return;
    }

    try {
      await _consent.loadAndShowConsentFormIfRequired((formError) {
        if (formError != null) {
          Log.error(
            'Consent form (if required) dismissed with error: '
            '${formError.message}',
          );
        } else {
          Log.info('Consent form (if required) dismissed');
        }
      });
    } on Exception catch (e) {
      Log.error('Error showing consent form before interstitial: $e');
    }

    final canRequest = await _consent.canRequestAds();
    if (!canRequest) {
      throw const AdsConsentChoicesOptedOutException(
        innerMessage: 'Ads cannot be requested until consent allows it',
      );
    }
  }

  Future<void> _loadAndShowConsentForm() async {
    try {
      await _consent.loadAndShowConsentForm();
    } on Exception catch (e) {
      Log.error('Error in consent flow: $e');
      // Continue with initialization even if consent fails
    }
  }

  Future<void> _checkAndShowConsentForm() async {
    try {
      final status = await _consent.getConsentStatus();
      final required = await _consent.isConsentFormAvailable();

      Log.info('Consent status: $status, Form required: $required');

      if (required && status == ConsentStatus.required) {
        await _loadAndShowConsentForm();
      }
    } on Exception catch (e) {
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
      _consent.requestConsentInfoUpdate(
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
    } on Exception catch (e) {
      Log.error('Error requesting consent: $e');
      // Continue with initialization even if consent fails
    }
  }

  Future<void> _preloadInterstitialAd() async {
    try {
      if (_isInitialized &&
          _inFlightInterstitialLoad == null &&
          _cachedInterstitialAd == null) {
        Log.info('Preloading interstitial ad');
        _cachedInterstitialAd = await _loadInterstitialAd();
      }
    } on Exception catch (e) {
      Log.error('Failed to preload interstitial ad: $e');
      // Don't rethrow, just log the error
    }
  }
}
