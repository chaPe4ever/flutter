import 'package:analytics/analytics.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inapp_review/exceptions/in_app_review_exceptions.dart';
import 'package:inapp_review/implementations/in_app_review_service_impl.dart';

import '../shared/in_app_review_test_doubles.dart';

void main() {
  late FakeInAppReview inAppReview;
  late FakeLocalStorage localStorage;
  late FakeNetwork network;
  late FakeLogger logger;
  late FakeAnalytics analytics;
  late DateTime clock;

  InAppReviewServiceImpl createService({
    LocalStorageBase? storage,
    NetworkBase? networkBase,
    AnalyticsBase? analyticsBase,
    DateTime Function()? getCurrentTime,
    FakeInAppReview? review,
  }) {
    return InAppReviewServiceImpl(
      inAppReview: review ?? inAppReview,
      localStorage: storage ?? localStorage,
      network: networkBase ?? network,
      logger: logger,
      analytics: analyticsBase,
      getCurrentTime: getCurrentTime ?? (() => clock),
    );
  }

  Future<InAppReviewServiceImpl> initializedService({
    Duration frequency = const Duration(days: 30),
    int maxPrompts = 3,
    LocalStorageBase? storage,
    DateTime Function()? getCurrentTime,
    FakeInAppReview? review,
  }) async {
    final service = createService(
      storage: storage,
      getCurrentTime: getCurrentTime,
      review: review,
    );
    await service.init(frequency: frequency, maxPrompts: maxPrompts);
    return service;
  }

  setUp(() {
    inAppReview = FakeInAppReview();
    localStorage = FakeLocalStorage();
    network = FakeNetwork();
    logger = FakeLogger();
    analytics = FakeAnalytics();
    clock = DateTime.utc(2025, 6, 1, 12);
  });

  group('InAppReviewServiceImpl.defaultGetCurrentTime', () {
    test('returns the current UTC time', () {
      final now = InAppReviewServiceImpl.defaultGetCurrentTime();

      expect(now.isUtc, isTrue);
      expect(now.difference(DateTime.now().toUtc()).inSeconds, lessThan(2));
    });
  });

  group('init', () {
    test('persists init config and seeds last review date', () async {
      final service = createService();

      await service.init(
        frequency: const Duration(days: 14),
        maxPrompts: 5,
      );

      expect(
        await localStorage.read<int>(
          InAppReviewServiceImpl.durationMillisecondsFrequencyKey,
        ),
        const Duration(days: 14).inMilliseconds,
      );
      expect(
        await localStorage.read<int>(InAppReviewServiceImpl.maxPromptsKey),
        5,
      );
      expect(
        await localStorage.read<String>(
          InAppReviewServiceImpl.lastReviewDateTimeKey,
        ),
        clock.toIso8601String(),
      );
      expect(
        logger.debugMessages.any((m) => m.contains('InAppReview initialized')),
        isTrue,
      );
    });

    test('does not overwrite an existing last review timestamp', () async {
      const savedAt = '2020-01-01T00:00:00.000Z';
      await localStorage.write(
        InAppReviewServiceImpl.lastReviewDateTimeKey,
        savedAt,
      );
      final service = createService();

      await service.init();

      expect(
        await localStorage.read<String>(
          InAppReviewServiceImpl.lastReviewDateTimeKey,
        ),
        savedAt,
      );
    });

    test('wraps storage failures as core exceptions', () async {
      final service = createService(
        storage: ThrowingLocalStorage(Exception('disk full')),
      );

      await expectLater(
        service.init(),
        throwsA(isA<UnknownCoreException>()),
      );
      expect(logger.errorMessages, isNotEmpty);
    });
  });

  group('resetShowFrequency', () {
    test('clears the last review timestamp when initialized', () async {
      final service = await initializedService();

      await service.resetShowFrequency();

      expect(
        await localStorage.read<String>(
          InAppReviewServiceImpl.lastReviewDateTimeKey,
        ),
        isNull,
      );
      expect(
        logger.debugMessages.any((m) => m.contains('frequency reset')),
        isTrue,
      );
    });

    test('throws when the service has not been initialized', () async {
      final service = createService();

      await expectLater(
        service.resetShowFrequency(),
        throwsA(isA<NotInitialisedInAppReviewException>()),
      );
    });
  });

  group('canShowReview', () {
    test('returns false before initialization', () async {
      final service = createService();

      expect(await service.canShowReview(), isFalse);
    });

    test('returns false when the user already completed a review', () async {
      final service = await initializedService();
      await localStorage.write(InAppReviewServiceImpl.reviewCompletedKey, true);

      expect(await service.canShowReview(), isFalse);
      expect(inAppReview.requestReviewCalls, 0);
    });

    test('returns false when the prompt limit is reached', () async {
      final service = await initializedService(maxPrompts: 2);
      await localStorage.write(InAppReviewServiceImpl.reviewPromptCountKey, 2);

      expect(await service.canShowReview(), isFalse);
    });

    test('returns false without network connectivity', () async {
      network.connected = false;
      final service = await initializedService();

      expect(await service.canShowReview(), isFalse);
    });

    test('returns false when in-app review is unavailable', () async {
      inAppReview.available = false;
      final service = await initializedService();

      expect(await service.canShowReview(), isFalse);
    });

    test('returns false until the configured frequency elapses', () async {
      final service = await initializedService();

      expect(await service.canShowReview(), isFalse);

      clock = clock.add(const Duration(days: 31));

      expect(await service.canShowReview(), isTrue);
    });

    test(
      'uses the default frequency when storage returns null later',
      () async {
        final storage = FrequencyNullOnSecondReadStorage();
        final service = await initializedService(storage: storage);
        clock = clock.add(const Duration(days: 31));

        expect(await service.canShowReview(), isTrue);
      },
    );

    test('returns false when the last review timestamp was cleared', () async {
      final service = await initializedService();
      await service.resetShowFrequency();

      expect(await service.canShowReview(), isFalse);
    });

    test('returns false when the stored timestamp is invalid', () async {
      final service = await initializedService();
      await localStorage.write(
        InAppReviewServiceImpl.lastReviewDateTimeKey,
        'not-a-date',
      );

      expect(await service.canShowReview(), isFalse);
      expect(logger.errorMessages, isNotEmpty);
    });
  });

  group('show', () {
    test('requests a review when conditions are met', () async {
      final service = await initializedService(frequency: Duration.zero);
      clock = clock.add(const Duration(minutes: 1));

      await service.show();

      expect(inAppReview.requestReviewCalls, 1);
      expect(
        await localStorage.read<int>(
          InAppReviewServiceImpl.reviewPromptCountKey,
        ),
        1,
      );
    });

    test('skips the prompt when conditions are not met', () async {
      final service = await initializedService();

      await service.show();

      expect(inAppReview.requestReviewCalls, 0);
      expect(
        logger.debugMessages.any(
          (m) => m.contains('conditions not met for showing review'),
        ),
        isTrue,
      );
    });
  });

  group('forceShow', () {
    test('shows the prompt when online and supported', () async {
      final service = await initializedService();

      await service.forceShow();

      expect(inAppReview.requestReviewCalls, 1);
      expect(
        logger.infoMessages.any((m) => m.contains('InAppReview forced show')),
        isTrue,
      );
    });

    test('throws when offline', () async {
      network.connected = false;
      final service = await initializedService();

      await expectLater(
        service.forceShow(),
        throwsA(isA<NoNetworkException>()),
      );
    });

    test('throws when the device does not support in-app review', () async {
      inAppReview.available = false;
      final service = await initializedService();

      await expectLater(
        service.forceShow(),
        throwsA(isA<InAppReviewNotSupportedDeviceException>()),
      );
    });

    test('throws when the service has not been initialized', () async {
      final service = createService();

      await expectLater(
        service.forceShow(),
        throwsA(isA<NotInitialisedInAppReviewException>()),
      );
    });
  });

  group('openStoreReview', () {
    test('opens the store listing and logs analytics', () async {
      final service = createService(analyticsBase: analytics);
      await service.init();

      await service.openStoreReview(
        appStoreId: '123',
        microsoftStoreId: 'ms-1',
      );

      expect(inAppReview.openStoreListingCalls, 1);
      expect(inAppReview.lastAppStoreId, '123');
      expect(inAppReview.lastMicrosoftStoreId, 'ms-1');
      expect(analytics.events, hasLength(1));
      expect(
        analytics.events.single,
        isA<FirebaseAnalyticsEvent>().having(
          (e) => e.name,
          'name',
          'app_review_store_opened',
        ),
      );
    });

    test('throws when the service has not been initialized', () async {
      final service = createService();

      await expectLater(
        service.openStoreReview(),
        throwsA(isA<NotInitialisedInAppReviewException>()),
      );
    });
  });

  group('markReviewCompleted', () {
    test('persists completion and logs analytics', () async {
      final service = createService(analyticsBase: analytics);
      await service.init();

      await service.markReviewCompleted();

      expect(
        await localStorage.read<bool>(
          InAppReviewServiceImpl.reviewCompletedKey,
        ),
        isTrue,
      );
      expect(analytics.events, hasLength(1));
      expect(
        analytics.events.single,
        isA<FirebaseAnalyticsEvent>().having(
          (e) => e.name,
          'name',
          'app_review_completed',
        ),
      );
    });

    test('throws when the service has not been initialized', () async {
      final service = createService();

      await expectLater(
        service.markReviewCompleted(),
        throwsA(isA<NotInitialisedInAppReviewException>()),
      );
    });
  });

  group('getPromptCount', () {
    test('returns zero before any prompt is shown', () async {
      final service = await initializedService();

      expect(await service.getPromptCount(), 0);
    });

    test('returns the persisted prompt count', () async {
      final service = await initializedService();
      await localStorage.write(InAppReviewServiceImpl.reviewPromptCountKey, 4);

      expect(await service.getPromptCount(), 4);
    });

    test('throws when the service has not been initialized', () async {
      final service = createService();

      await expectLater(
        service.getPromptCount(),
        throwsA(isA<NotInitialisedInAppReviewException>()),
      );
    });
  });

  group('review prompt side effects', () {
    test('tracks analytics after a successful prompt', () async {
      final service = createService(analyticsBase: analytics);
      await service.init(frequency: Duration.zero);
      clock = clock.add(const Duration(minutes: 1));

      await service.show();

      expect(analytics.events, hasLength(1));
      final event = analytics.events.single as FirebaseAnalyticsEvent;
      expect(event.name, 'app_review_prompted');
      expect(event.parameters?['prompt_count'], '1');
      expect(event.parameters?['was_shown'], 'true');
      expect(event.parameters?['forced'], 'false');
    });

    test('marks forced prompts in analytics', () async {
      final service = createService(analyticsBase: analytics);
      await service.init();

      await service.forceShow();

      final event = analytics.events.single as FirebaseAnalyticsEvent;
      expect(event.parameters?['forced'], 'true');
    });
  });
}
