import 'package:ads/exceptions/ads_exceptions.dart';
import 'package:ads/implementations/google_consent_client.dart';
import 'package:ads/pods/ads.dart';
import 'package:ads/pods/interstitial_ad_load_config.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';

import '../shared/ads_test_container.dart';
import '../shared/failing_check_consent_information.dart';
import '../shared/fake_consent_client.dart';
import '../shared/fake_interstitial_ad_loader.dart';
import '../shared/fake_mobile_ads_client.dart';
import '../shared/google_mobile_ads_test_harness.dart';
import '../shared/throwing_consent_information.dart';
import '../shared/throwing_get_consent_status_client.dart';
import '../shared/throwing_load_and_show_if_required_client.dart';
import '../shared/throwing_show_consent_client.dart';

Future<void> _drainPendingAdWork() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void _expectAdsPodError(ProviderContainer container, Object? matcher) {
  final state = container.read(adsPod);
  expect(state, isA<AsyncError<void>>());
  expect(state.error, matcher);
}

int _platformAdId(GoogleMobileAdsTestHarness harness) {
  final ad = harness.lastInterstitialAd;
  if (ad == null) {
    return 0;
  }
  return instanceManager.adIdFor(ad) ?? 0;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GoogleMobileAdsTestHarness harness;

  setUp(() {
    harness = GoogleMobileAdsTestHarness.install();
  });

  tearDown(GoogleMobileAdsTestHarness.reset);

  group('Ads.build', () {
    test('starts in a completed data state', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);

      await expectLater(container.read(adsPod.future), completes);
      expect(container.read(adsPod), isA<AsyncData<void>>());
    });

    test('disposes cached ads when the provider is torn down', () async {
      final container = createAdsTestContainer();
      harness.interstitialLoadBehavior = InterstitialLoadBehavior.success;
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      expect(harness.lastInterstitialAd, isNotNull);

      container.dispose();
    });
  });

  group('Ads.init', () {
    test(
      'initializes mobile ads and preloads when consent is skipped',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(
          interstitialAdUnitId: 'test-unit',
          skipConsentForm: true,
        );
        await Future<void>.delayed(Duration.zero);

        expect(harness.lastInterstitialAd, isNotNull);
      },
    );

    test('runs the consent update flow when forms are not skipped', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness
        ..consentFormAvailable = true
        ..consentStatus = ConsentStatus.required;

      await notifier.init(interstitialAdUnitId: 'test-unit');
      await Future<void>.delayed(Duration.zero);

      expect(harness.lastInterstitialAd, isNotNull);
    });

    test('continues when consent info update fails', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness.failConsentInfoUpdate = true;

      await notifier.init(interstitialAdUnitId: 'test-unit');
      await Future<void>.delayed(Duration.zero);

      expect(harness.lastInterstitialAd, isNotNull);
    });

    test('swallows mobile ads initialization failures', () async {
      final mobileAds = FakeMobileAdsClient(failInitialize: true);
      final container = createAdsTestContainer(mobileAds: mobileAds);
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await expectLater(
        notifier.init(
          interstitialAdUnitId: 'test-unit',
          skipConsentForm: true,
        ),
        completes,
      );
    });

    test('does not reinitialize when init is called twice', () async {
      final mobileAds = FakeMobileAdsClient();
      final container = createAdsTestContainer(mobileAds: mobileAds);
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'first',
        skipConsentForm: true,
      );
      mobileAds.failInitialize = true;

      await notifier.init(
        interstitialAdUnitId: 'second',
        skipConsentForm: true,
      );

      expect(mobileAds.initializeCalls, 1);
    });
  });

  group('Ads.isConsetnFormAvailable', () {
    test('delegates to the UMP consent information API', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness.consentFormAvailable = true;

      expect(await notifier.isConsetnFormAvailable, isTrue);
    });
  });

  group('Ads.resetConsent', () {
    test('skips showing a form when consent forms are disabled', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );

      await expectLater(notifier.resetConsent(), completes);
    });

    test(
      'requests consent again when a form is available after reset',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(interstitialAdUnitId: 'unit');
        harness.consentFormAvailable = true;

        await notifier.resetConsent();
        await Future<void>.delayed(Duration.zero);

        expect(harness.consentFormAvailable, isTrue);
      },
    );

    test('logs and returns when no form is available after reset', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(interstitialAdUnitId: 'unit');
      harness.consentFormAvailable = false;

      await expectLater(notifier.resetConsent(), completes);
    });
  });

  group('Ads.showInterstitialAd', () {
    test('invokes dismiss callback when skip is true', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      var dismissed = false;

      await notifier.showInterstitialAd(
        skip: true,
        onAdDismissedFullScreenContent: () => dismissed = true,
      );

      expect(dismissed, isTrue);
    });

    test('throws when ads were never initialized', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await expectLater(
        notifier.showInterstitialAd(),
        throwsA(isA<AdsInitException>()),
      );
    });

    test('loads and shows an interstitial on the happy path', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await Future<void>.delayed(Duration.zero);

      await notifier.showInterstitialAd();

      expect(container.read(adsPod), isA<AsyncData<void>>());
    });

    test(
      'fires fullscreen callbacks when the platform reports ad events',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(
          interstitialAdUnitId: 'unit',
          skipConsentForm: true,
        );
        await Future<void>.delayed(Duration.zero);

        var showed = false;
        var dismissed = false;

        await notifier.showInterstitialAd(
          onAdShowedFullScreenContent: () => showed = true,
          onAdDismissedFullScreenContent: () => dismissed = true,
        );

        await harness.dispatchAdEvent(
          adId: _platformAdId(harness),
          eventName: harness.showedFullScreenEvent,
        );
        await harness.dispatchAdEvent(
          adId: _platformAdId(harness),
          eventName: harness.dismissedFullScreenEvent,
        );

        expect(showed, isTrue);
        expect(dismissed, isTrue);
      },
    );

    test(
      'updates request configuration when test device ids are provided',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(
          interstitialAdUnitId: 'unit',
          skipConsentForm: true,
        );

        await notifier.showInterstitialAd(
          testDeviceIds: const ['device-a'],
        );

        expect(container.read(adsPod), isA<AsyncData<void>>());
      },
    );

    test('maps a no-fill load error to AdsNoFillException', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness.interstitialLoadBehavior = InterstitialLoadBehavior.noFill;

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      CoreException? reported;

      await notifier.showInterstitialAd(
        onAdFailedToShowFullScreenContent: (error) => reported = error,
      );

      expect(reported, isA<AdsNoFillException>());
      _expectAdsPodError(container, isA<AdsNoFillException>());
    });

    test(
      'remaps no-fill to consent opt-out when ads later cannot be requested',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        harness
          ..canRequestAds = true
          ..canRequestAdsOnceBeforeDeny = true
          ..interstitialLoadBehavior = InterstitialLoadBehavior.noFill;

        await notifier.init(interstitialAdUnitId: 'unit');
        await _drainPendingAdWork();

        CoreException? reported;
        await notifier.showInterstitialAd(
          onAdFailedToShowFullScreenContent: (error) => reported = error,
        );

        expect(reported, isA<AdsConsentChoicesOptedOutException>());
        _expectAdsPodError(
          container,
          isA<AdsConsentChoicesOptedOutException>(),
        );
      },
    );

    test('maps network load failures to AdsBlockerException', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness.interstitialLoadBehavior = InterstitialLoadBehavior.networkError;

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      await notifier.showInterstitialAd();
      _expectAdsPodError(container, isA<AdsBlockerException>());
    });

    test('maps consent-related load failures', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness.interstitialLoadBehavior = InterstitialLoadBehavior.consentError;

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      await notifier.showInterstitialAd();
      _expectAdsPodError(container, isA<AdsConsentChoicesOptedOutException>());
    });

    test('maps no-fill wording on code 3 to inventory unavailable', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness.interstitialLoadBehavior =
          InterstitialLoadBehavior.noFillWithMessage;

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      await notifier.showInterstitialAd();
      _expectAdsPodError(container, isA<AdsNoFillException>());
    });

    test('maps unknown load failures to AdsLoadException', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness.interstitialLoadBehavior = InterstitialLoadBehavior.genericError;

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      await notifier.showInterstitialAd();
      _expectAdsPodError(container, isA<AdsLoadException>());
    });

    test(
      'records an error when consent blocks ad requests before loading',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(interstitialAdUnitId: 'unit');
        harness.canRequestAds = false;

        await notifier.showInterstitialAd();
        _expectAdsPodError(
          container,
          isA<AdsConsentChoicesOptedOutException>(),
        );
      },
    );

    test(
      'reports inventory unavailable when show fails with no fill',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(
          interstitialAdUnitId: 'unit',
          skipConsentForm: true,
        );
        await Future<void>.delayed(Duration.zero);

        CoreException? reported;
        final showFuture = notifier.showInterstitialAd(
          onAdFailedToShowFullScreenContent: (error) => reported = error,
        );
        await _drainPendingAdWork();

        await harness.dispatchAdEvent(
          adId: _platformAdId(harness),
          eventName: harness.failedToShowFullScreenEvent,
          extra: {'error': AdError(1, 'domain', 'no fill')},
        );

        await showFuture;
        expect(reported, isA<AdsNoFillException>());
      },
    );

    test(
      'reports inventory unavailable when code 3 mentions no fill',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(
          interstitialAdUnitId: 'unit',
          skipConsentForm: true,
        );
        await Future<void>.delayed(Duration.zero);

        CoreException? reported;
        final showFuture = notifier.showInterstitialAd(
          onAdFailedToShowFullScreenContent: (error) => reported = error,
        );
        await _drainPendingAdWork();

        await harness.dispatchAdEvent(
          adId: _platformAdId(harness),
          eventName: harness.failedToShowFullScreenEvent,
          extra: {'error': AdError(3, 'domain', 'No fill from server')},
        );

        await showFuture;
        expect(reported, isA<AdsNoFillException>());
      },
    );

    test('reports ad blocker failures when show fails with code 2', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await Future<void>.delayed(Duration.zero);

      CoreException? reported;
      final showFuture = notifier.showInterstitialAd(
        onAdFailedToShowFullScreenContent: (error) => reported = error,
      );
      await _drainPendingAdWork();

      await harness.dispatchAdEvent(
        adId: _platformAdId(harness),
        eventName: harness.failedToShowFullScreenEvent,
        extra: {'error': AdError(2, 'domain', 'network')},
      );

      await showFuture;
      expect(reported, isA<AdsBlockerException>());
    });

    test('reports consent opt-out when show fails with code 3', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await Future<void>.delayed(Duration.zero);

      CoreException? reported;
      final showFuture = notifier.showInterstitialAd(
        onAdFailedToShowFullScreenContent: (error) => reported = error,
      );
      await _drainPendingAdWork();

      await harness.dispatchAdEvent(
        adId: _platformAdId(harness),
        eventName: harness.failedToShowFullScreenEvent,
        extra: {'error': AdError(3, 'domain', 'consent')},
      );

      await showFuture;
      expect(reported, isA<AdsConsentChoicesOptedOutException>());
    });

    test('reports generic show failures for unknown error codes', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await Future<void>.delayed(Duration.zero);

      CoreException? reported;
      final showFuture = notifier.showInterstitialAd(
        onAdFailedToShowFullScreenContent: (error) => reported = error,
      );
      await _drainPendingAdWork();

      await harness.dispatchAdEvent(
        adId: _platformAdId(harness),
        eventName: harness.failedToShowFullScreenEvent,
        extra: {'error': AdError(99, 'domain', 'other')},
      );

      await showFuture;
      expect(reported, isA<AdsShowException>());
    });

    test('reuses a cached interstitial when one is already loaded', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      await notifier.showInterstitialAd();
      await notifier.showInterstitialAd();

      expect(container.read(adsPod), isA<AsyncData<void>>());
    });

    test('preloads the next ad after a fullscreen show succeeds', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      await notifier.showInterstitialAd();
      await harness.dispatchAdEvent(
        adId: _platformAdId(harness),
        eventName: harness.showedFullScreenEvent,
      );
      await _drainPendingAdWork();

      expect(harness.lastInterstitialAd, isNotNull);
    });
  });

  group('consent form edge cases', () {
    test('continues init when consent form load fails', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness
        ..consentFormAvailable = true
        ..consentStatus = ConsentStatus.required
        ..failLoadConsentForm = true;

      await expectLater(
        notifier.init(interstitialAdUnitId: 'unit'),
        completes,
      );
      await _drainPendingAdWork();
    });

    test('continues when showing the consent form throws', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness
        ..consentFormAvailable = true
        ..consentStatus = ConsentStatus.required;

      await notifier.init(interstitialAdUnitId: 'unit');
      harness.loadAndShowConsentFormError = FormError(
        errorCode: 1,
        message: 'dismissed with error',
      );

      await expectLater(
        notifier.showInterstitialAd(),
        completes,
      );
    });

    test('records a consent form error when loadAndShow returns one', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(interstitialAdUnitId: 'unit');
      harness.loadAndShowConsentFormError = FormError(
        errorCode: 2,
        message: 'blocked',
      );

      await notifier.showInterstitialAd();
    });
  });

  group('Ads coverage edge cases', () {
    test('shares one in-flight interstitial load across callers', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      final first = notifier.showInterstitialAd();
      final second = notifier.showInterstitialAd();

      await expectLater(Future.wait([first, second]), completes);
    });

    test('throws when ad configuration was cleared before loading', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();
      await notifier.showInterstitialAd();
      container.read(interstitialAdLoadConfigPod.notifier).clear();

      await notifier.showInterstitialAd();
      _expectAdsPodError(
        container,
        isA<AdsInitException>().having(
          (e) => e.innerMessage,
          'innerMessage',
          'Ad unit ID or AdRequest is null',
        ),
      );
    });

    test(
      'surfaces load failures when waiting for the interstitial future',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        harness.interstitialLoadBehavior =
            InterstitialLoadBehavior.networkError;

        await notifier.init(
          interstitialAdUnitId: 'unit',
          skipConsentForm: true,
        );
        await _drainPendingAdWork();

        await notifier.showInterstitialAd();
        _expectAdsPodError(container, isA<AdsBlockerException>());
      },
    );

    test('rethrows when the platform channel throws while loading', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness.interstitialLoadBehavior = InterstitialLoadBehavior.throwOnLoad;

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();

      await notifier.showInterstitialAd();
      _expectAdsPodError(container, isA<Exception>());
    });

    test('logs and continues when preloading fails', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness.interstitialLoadBehavior = InterstitialLoadBehavior.noFill;

      await notifier.init(
        interstitialAdUnitId: 'unit',
        skipConsentForm: true,
      );
      await _drainPendingAdWork();
    });

    test('continues init when consent form availability check fails', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness
        ..consentFormAvailable = true
        ..consentStatus = ConsentStatus.required
        ..failIsConsentFormAvailable = true;

      await expectLater(
        notifier.init(interstitialAdUnitId: 'unit'),
        completes,
      );
      await _drainPendingAdWork();
    });

    test('continues init when checking consent status fails', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness
        ..consentFormAvailable = true
        ..consentStatus = ConsentStatus.required
        ..failGetConsentStatusAfterCallCount = 3;

      await expectLater(
        notifier.init(interstitialAdUnitId: 'unit'),
        completes,
      );
      await _drainPendingAdWork();
    });

    test('continues init when consent form show returns an error', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness
        ..consentFormAvailable = true
        ..consentStatus = ConsentStatus.required
        ..consentFormShowError = FormError(
          errorCode: 3,
          message: 'user dismissed with error',
        );

      await expectLater(
        notifier.init(interstitialAdUnitId: 'unit'),
        completes,
      );
      await _drainPendingAdWork();
    });

    test('continues init when consent form show throws', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness
        ..consentFormAvailable = true
        ..consentStatus = ConsentStatus.required
        ..failConsentFormShow = true;

      await expectLater(
        notifier.init(interstitialAdUnitId: 'unit'),
        completes,
      );
      await _drainPendingAdWork();
    });

    test(
      'continues init when requesting consent throws synchronously',
      () async {
        final container = createAdsTestContainer(
          consentClient: GoogleConsentClient(
            consentInformation: ThrowingConsentInformation(),
          ),
        );
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await expectLater(
          notifier.init(interstitialAdUnitId: 'unit'),
          completes,
        );
      },
    );

    test('logs when the consent form dismisses without an error', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      await notifier.init(interstitialAdUnitId: 'unit');
      harness.loadAndShowConsentFormError = null;

      await expectLater(notifier.showInterstitialAd(), completes);
    });

    test(
      'continues when load-and-show consent throws before interstitial',
      () async {
        final container = createAdsTestContainer(
          consentClient: ThrowingLoadAndShowIfRequiredClient(),
        );
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(interstitialAdUnitId: 'unit');

        await expectLater(notifier.showInterstitialAd(), completes);
      },
    );

    test(
      'surfaces load failures when consent status cannot be read',
      () async {
        final container = createAdsTestContainer(
          consentClient: ThrowingGetConsentStatusClient(),
        );
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(
          interstitialAdUnitId: 'unit',
          skipConsentForm: true,
        );
        await _drainPendingAdWork();

        await notifier.showInterstitialAd();
        _expectAdsPodError(container, isA<Exception>());
      },
    );

    test(
      'continues init when the post-update consent check throws',
      () async {
        final container = createAdsTestContainer(
          consentClient: GoogleConsentClient(
            consentInformation: FailingCheckConsentInformation(),
          ),
        );
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await expectLater(
          notifier.init(interstitialAdUnitId: 'unit'),
          completes,
        );
        await _drainPendingAdWork();
      },
    );

    test(
      'uses non-personalized ad requests when consent is not obtained',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        harness.consentStatus = ConsentStatus.required;

        await notifier.init(
          interstitialAdUnitId: 'unit',
          skipConsentForm: true,
        );
        await _drainPendingAdWork();

        await notifier.showInterstitialAd();
      },
    );

    test(
      'clears the in-flight completer when the load future fails early',
      () async {
        final loader = FakeInterstitialAdLoader();
        final container = createAdsTestContainer(
          interstitialAdLoader: loader,
        );
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        await notifier.init(
          interstitialAdUnitId: 'unit',
          skipConsentForm: true,
        );

        loader.holdNextLoad();

        final showFuture = notifier.showInterstitialAd();
        await _drainPendingAdWork();

        loader.completePendingLoadError(
          Exception('manual load wait failure'),
        );

        await showFuture;
        _expectAdsPodError(container, isA<Exception>());
      },
    );

    test('completes consent init when the form closes cleanly', () async {
      final container = createAdsTestContainer();
      addTearDown(container.dispose);
      final notifier = await readAdsNotifier(container);

      harness
        ..consentFormAvailable = true
        ..consentStatus = ConsentStatus.required;

      await expectLater(
        notifier.init(interstitialAdUnitId: 'unit'),
        completes,
      );
      await _drainPendingAdWork();
    });

    test(
      'continues init when consent form show throws synchronously',
      () async {
        final container = createAdsTestContainer(
          consentClient: ThrowingShowConsentClient(),
        );
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        harness
          ..consentFormAvailable = true
          ..consentStatus = ConsentStatus.required;

        await expectLater(
          notifier.init(interstitialAdUnitId: 'unit'),
          completes,
        );
        await _drainPendingAdWork();
      },
    );

    test(
      'continues init when consent form show returns a form error',
      () async {
        final container = createAdsTestContainer();
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        harness
          ..consentFormAvailable = true
          ..consentStatus = ConsentStatus.required
          ..consentFormShowError = FormError(
            errorCode: 4,
            message: 'show returned error',
          );

        await expectLater(
          notifier.init(interstitialAdUnitId: 'unit'),
          completes,
        );
        await _drainPendingAdWork();
      },
    );

    test(
      'continues init when loading the consent form throws at the start',
      () async {
        final container = createAdsTestContainer(
          consentClient: FakeConsentClient(
            throwOnLoadAndShowConsentForm: true,
          ),
        );
        addTearDown(container.dispose);
        final notifier = await readAdsNotifier(container);

        harness
          ..consentFormAvailable = true
          ..consentStatus = ConsentStatus.required;

        await expectLater(
          notifier.init(interstitialAdUnitId: 'unit'),
          completes,
        );
      },
    );
  });
}
