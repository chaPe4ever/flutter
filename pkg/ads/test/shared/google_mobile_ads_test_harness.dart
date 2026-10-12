import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';
import 'package:google_mobile_ads/src/ump/consent_form_impl.dart';
import 'package:google_mobile_ads/src/ump/consent_information_impl.dart';
import 'package:google_mobile_ads/src/ump/user_messaging_channel.dart';
import 'package:google_mobile_ads/src/ump/user_messaging_codec.dart';

/// Test harness patterned after google_mobile_ads plugin tests.
class GoogleMobileAdsTestHarness {
  GoogleMobileAdsTestHarness._({
    required this.adsChannel,
    required this.umpChannel,
    required this.consentInformation,
    required this.userMessagingChannel,
  });

  final MethodChannel adsChannel;
  final MethodChannel umpChannel;
  final ConsentInformation consentInformation;
  final UserMessagingChannel userMessagingChannel;

  static ConsentInformation? _savedConsentInformation;
  static UserMessagingChannel? _savedUserMessagingChannel;

  InterstitialLoadBehavior interstitialLoadBehavior =
      InterstitialLoadBehavior.success;

  bool holdInterstitialLoadCompletion = false;
  Completer<void>? _heldInterstitialLoadGate;

  int? _lastInterstitialAdId;

  static GoogleMobileAdsTestHarness install() {
    TestWidgetsFlutterBinding.ensureInitialized();

    _savedConsentInformation = ConsentInformation.instance;
    _savedUserMessagingChannel = UserMessagingChannel.instance;

    final harness = GoogleMobileAdsTestHarness._(
      adsChannel: MethodChannel(
        'plugins.flutter.io/google_mobile_ads',
        StandardMethodCodec(AdMessageCodec()),
      ),
      umpChannel: MethodChannel(
        'plugins.flutter.io/google_mobile_ads/ump',
        StandardMethodCodec(UserMessagingCodec()),
      ),
      consentInformation: ConsentInformation.instance,
      userMessagingChannel: UserMessagingChannel.instance,
    );

    instanceManager = AdInstanceManager('plugins.flutter.io/google_mobile_ads');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(harness.adsChannel, (call) async {
          return harness._handleAdsCall(call);
        });

    UserMessagingChannel.instance = UserMessagingChannel(harness.umpChannel);
    ConsentInformation.instance = ConsentInformationImpl();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(harness.umpChannel, (call) async {
          return harness._handleUmpCall(call);
        });

    return harness;
  }

  static void reset() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/google_mobile_ads'),
          null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/google_mobile_ads/ump'),
          null,
        );
    if (_savedUserMessagingChannel != null) {
      UserMessagingChannel.instance = _savedUserMessagingChannel!;
    }
    if (_savedConsentInformation != null) {
      ConsentInformation.instance = _savedConsentInformation!;
    }
    _savedConsentInformation = null;
    _savedUserMessagingChannel = null;
  }

  bool consentFormAvailable = false;
  ConsentStatus consentStatus = ConsentStatus.obtained;
  bool canRequestAds = true;
  bool canRequestAdsOnceBeforeDeny = false;
  int _canRequestAdsCalls = 0;
  bool failConsentInfoUpdate = false;
  bool failLoadConsentForm = false;
  FormError? loadAndShowConsentFormError;
  bool failMobileAdsInitialize = false;
  bool failConsentFormShow = false;
  bool failGetConsentStatus = false;
  int? failGetConsentStatusAfterCallCount;
  int _getConsentStatusCalls = 0;
  bool failRequestConsentInfoUpdate = false;
  bool failIsConsentFormAvailable = false;
  bool failLoadAndShowConsentFormIfRequired = false;
  FormError? consentFormShowError;

  Future<Object?> _handleAdsCall(MethodCall call) async {
    switch (call.method) {
      case 'MobileAds#initialize':
      case '_init':
        if (failMobileAdsInitialize) {
          throw PlatformException(code: 'init_failed', message: 'init failed');
        }
        return InitializationStatus(<String, AdapterStatus>{});
      case 'MobileAds#updateRequestConfiguration':
      case 'setImmersiveMode':
      case 'showAdWithoutView':
      case 'disposeAd':
        return null;
      case 'loadInterstitialAd':
        final args = call.arguments! as Map<Object?, Object?>;
        final adId = args['adId']! as int;
        _lastInterstitialAdId = adId;
        await _completeInterstitialLoad(adId);
        return null;
      default:
        return null;
    }
  }

  void releaseHeldInterstitialLoad() {
    _heldInterstitialLoadGate?.complete();
    _heldInterstitialLoadGate = null;
  }

  Future<void> _completeInterstitialLoad(int adId) async {
    final ad = instanceManager.adFor(adId);
    if (ad is! InterstitialAd) {
      return;
    }
    if (holdInterstitialLoadCompletion) {
      _heldInterstitialLoadGate ??= Completer<void>();
      await _heldInterstitialLoadGate!.future;
    }
    await Future<void>.microtask(() {
      switch (interstitialLoadBehavior) {
        case InterstitialLoadBehavior.success:
          ad.adLoadCallback.onAdLoaded(ad);
        case InterstitialLoadBehavior.noFill:
          ad.adLoadCallback.onAdFailedToLoad(
            LoadAdError(1, 'domain', 'no fill', null),
          );
        case InterstitialLoadBehavior.networkError:
          ad.adLoadCallback.onAdFailedToLoad(
            LoadAdError(2, 'domain', 'network', null),
          );
        case InterstitialLoadBehavior.consentError:
          ad.adLoadCallback.onAdFailedToLoad(
            LoadAdError(3, 'domain', 'consent', null),
          );
        case InterstitialLoadBehavior.noFillWithMessage:
          ad.adLoadCallback.onAdFailedToLoad(
            LoadAdError(3, 'domain', 'No fill for request', null),
          );
        case InterstitialLoadBehavior.genericError:
          ad.adLoadCallback.onAdFailedToLoad(
            LoadAdError(99, 'domain', 'other', null),
          );
        case InterstitialLoadBehavior.throwOnLoad:
          throw Exception('load channel blew up');
        case InterstitialLoadBehavior.silent:
          break;
      }
    });
  }

  Future<Object?> _handleUmpCall(MethodCall call) async {
    switch (call.method) {
      case 'ConsentInformation#requestConsentInfoUpdate':
        if (failConsentInfoUpdate || failRequestConsentInfoUpdate) {
          throw PlatformException(code: '1', message: 'consent update failed');
        }
        return null;
      case 'ConsentInformation#isConsentFormAvailable':
        if (failIsConsentFormAvailable) {
          throw PlatformException(code: '4', message: 'availability failed');
        }
        return consentFormAvailable;
      case 'ConsentInformation#getConsentStatus':
        _getConsentStatusCalls++;
        if (failGetConsentStatus ||
            (failGetConsentStatusAfterCallCount != null &&
                _getConsentStatusCalls >=
                    failGetConsentStatusAfterCallCount!)) {
          throw PlatformException(code: '2', message: 'status failed');
        }
        return _consentStatusInt(consentStatus);
      case 'ConsentInformation#reset':
        return null;
      case 'ConsentInformation#canRequestAds':
        _canRequestAdsCalls++;
        if (canRequestAdsOnceBeforeDeny && _canRequestAdsCalls > 1) {
          return false;
        }
        return canRequestAds;
      case 'ConsentInformation#getPrivacyOptionsRequirementStatus':
        return 0;
      case 'UserMessagingPlatform#loadConsentForm':
        if (failLoadConsentForm) {
          throw PlatformException(code: '2', message: 'form load failed');
        }
        return ConsentFormImpl(1);
      case 'UserMessagingPlatform#loadAndShowConsentFormIfRequired':
        if (failLoadAndShowConsentFormIfRequired) {
          throw Exception('load and show failed');
        }
        return loadAndShowConsentFormError;
      case 'ConsentForm#show':
        if (failConsentFormShow) {
          throw PlatformException(code: '3', message: 'show failed');
        }
        return consentFormShowError;
      case 'ConsentForm#dispose':
        return null;
      default:
        return null;
    }
  }

  int _consentStatusInt(ConsentStatus status) {
    switch (status) {
      case ConsentStatus.unknown:
        return 0;
      case ConsentStatus.required:
        return 2;
      case ConsentStatus.notRequired:
        return 1;
      case ConsentStatus.obtained:
        return 3;
    }
  }

  InterstitialAd? get lastInterstitialAd {
    final id = _lastInterstitialAdId;
    if (id == null) {
      return null;
    }
    return instanceManager.adFor(id) as InterstitialAd?;
  }

  String get showedFullScreenEvent =>
      defaultTargetPlatform == TargetPlatform.android
      ? 'onAdShowedFullScreenContent'
      : 'adWillPresentFullScreenContent';

  String get dismissedFullScreenEvent =>
      defaultTargetPlatform == TargetPlatform.android
      ? 'onAdDismissedFullScreenContent'
      : 'adDidDismissFullScreenContent';

  String get failedToShowFullScreenEvent =>
      defaultTargetPlatform == TargetPlatform.android
      ? 'onFailedToShowFullScreenContent'
      : 'didFailToPresentFullScreenContentWithError';

  Future<void> dispatchAdEvent({
    required int adId,
    required String eventName,
    Map<dynamic, dynamic> extra = const {},
  }) async {
    final methodCall = MethodCall(
      'onAdEvent',
      <dynamic, dynamic>{
        'adId': adId,
        'eventName': eventName,
        ...extra,
      },
    );
    final data = instanceManager.channel.codec.encodeMethodCall(methodCall);
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          'plugins.flutter.io/google_mobile_ads',
          data,
          (_) {},
        );
  }
}

enum InterstitialLoadBehavior {
  success,
  noFill,
  networkError,
  consentError,
  noFillWithMessage,
  genericError,
  throwOnLoad,
  silent,
}
