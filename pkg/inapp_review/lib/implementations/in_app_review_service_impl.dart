import 'package:analytics/contracts/analytics_base.dart';
import 'package:analytics/unions/analytics_event.dart';
import 'package:core/core.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:inapp_review/contracts/in_app_review_service_base.dart';
import 'package:inapp_review/exceptions/in_app_review_exceptions.dart';

/// Implementation of the in-app review service
final class InAppReviewServiceImpl implements InAppReviewServiceBase {
  /// Creates a new instance of the InAppReviewServiceImpl
  ///
  /// Requires:
  /// - [inAppReview] - Platform in-app review API
  /// - [localStorage] - Storage for tracking review state
  /// - [network] - Network connectivity checker
  /// - [logger] - Logging service
  /// - [analytics] - Optional analytics service
  const InAppReviewServiceImpl({
    required this.inAppReview,
    required this.localStorage,
    required this.network,
    required this.logger,
    this.analytics,
    this.getCurrentTime = defaultGetCurrentTime,
  });

  final InAppReview inAppReview;
  final LocalStorageBase localStorage;
  final NetworkBase network;
  final LoggerBase logger;
  final AnalyticsBase? analytics;

  /// Function to get current time - can be overridden for testing
  final DateTime Function() getCurrentTime;

  /// Default implementation of getCurrentTime
  static DateTime defaultGetCurrentTime() => DateTime.now().toUtc();

  // Storage keys
  static const lastReviewDateTimeKey = 'last_app_review_date_time_key';
  static const durationMillisecondsFrequencyKey =
      'duration_milliseconds_frequency';
  static const reviewPromptCountKey = 'review_prompt_count_key';
  static const maxPromptsKey = 'max_review_prompts_key';
  static const reviewCompletedKey = 'review_completed_key';

  @override
  Future<void> init({
    Duration frequency = const Duration(days: 30),
    int maxPrompts = 3,
  }) => _executeWithErrorHandling(() async {
    await localStorage.write(
      durationMillisecondsFrequencyKey,
      frequency.inMilliseconds,
    );

    await localStorage.write(maxPromptsKey, maxPrompts);

    // Initialize prompt count if not already set
    if (localStorage.read<int>(reviewPromptCountKey) == null) {
      await localStorage.write(reviewPromptCountKey, 0);
    }

    logger.d(
      'InAppReview initialized with frequency: $frequency, max prompts: $maxPrompts',
    );
  });

  @override
  Future<void> resetShowFrequency() => _executeWithErrorHandling(() async {
    _checkInitialized();
    await localStorage.remove(lastReviewDateTimeKey);
    logger.d('InAppReview frequency reset');
  });

  @override
  Future<void> show() => _executeWithErrorHandling(() async {
    final canShow = await canShowReview();

    if (canShow) {
      await _showReviewPrompt();
    } else {
      logger.d('InAppReview conditions not met for showing review');
    }
  });

  @override
  Future<bool> canShowReview() => _executeWithErrorHandling(() async {
    try {
      // Check if service is initialized
      _checkInitialized();

      // Check if review is already completed
      final reviewCompleted =
          localStorage.read<bool>(reviewCompletedKey) ?? false;
      if (reviewCompleted) {
        logger.d('InAppReview already completed by user');
        return false;
      }

      // Check prompt count
      final promptCount = await getPromptCount();
      final maxPrompts = localStorage.read<int>(maxPromptsKey) ?? 3;
      if (promptCount >= maxPrompts) {
        logger.d('InAppReview max prompts reached: $promptCount/$maxPrompts');
        return false;
      }

      // Check network connectivity
      final isConnected = await network.isConnected;
      if (!isConnected) {
        logger.d('InAppReview no network connection');
        return false;
      }

      // Check device support
      final isAvailable = await inAppReview.isAvailable();
      if (!isAvailable) {
        logger.d('InAppReview not supported on this device');
        return false;
      }

      // Check timing frequency
      final lastReviewDt = localStorage.read<String>(lastReviewDateTimeKey);
      if (lastReviewDt == null) {
        // First time - don't show yet, just record the timestamp
        return false;
      } else {
        final lastAppReviewDt = DateTime.parse(lastReviewDt);
        final durationFrequency = _getFrequencyDuration();
        final nowUtc = getCurrentTime();

        // Check if enough time has passed
        return nowUtc.difference(lastAppReviewDt) >= durationFrequency;
      }
    } catch (e) {
      logger.e('Error checking if review can be shown', e: e);
      return false;
    }
  });

  @override
  Future<void> forceShow() => _executeWithErrorHandling(() async {
    _checkInitialized();

    // Check network
    final isConnected = await network.isConnected;
    if (!isConnected) {
      throw const NoNetworkException();
    }

    // Check device support
    final isAvailable = await inAppReview.isAvailable();
    if (!isAvailable) {
      throw const InAppReviewNotSupportedDeviceException();
    }

    await _showReviewPrompt(ignoreFrequency: true);
    logger.i('InAppReview forced show');
  });

  @override
  Future<void> openStoreReview({
    String? appStoreId,
    String? microsoftStoreId,
  }) => _executeWithErrorHandling(() async {
    _checkInitialized();

    await inAppReview.openStoreListing(
      appStoreId: appStoreId,
      microsoftStoreId: microsoftStoreId,
    );
    logger.i('InAppReview opened store listing');

    // Track the event
    await analytics?.logEvent(
      analyticsEvent: FirebaseAnalyticsEvent(name: 'app_review_store_opened'),
    );
  });

  @override
  Future<void> markReviewCompleted() => _executeWithErrorHandling(() async {
    _checkInitialized();

    await localStorage.write(reviewCompletedKey, true);
    logger.i('InAppReview marked as completed');

    // Track the event
    await analytics?.logEvent(
      analyticsEvent: FirebaseAnalyticsEvent(name: 'app_review_completed'),
    );
  });

  @override
  Future<int> getPromptCount() => _executeWithErrorHandling(() async {
    _checkInitialized();
    return localStorage.read<int>(reviewPromptCountKey) ?? 0;
  });

  // PRIVATE METHODS

  /// Execute a function with standardized error handling
  Future<T> _executeWithErrorHandling<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e, st) {
      logger.e('InAppReview caught exception', e: e, st: st);
      throw e.toCoreException();
    }
  }

  /// Check if the service has been initialized
  void _checkInitialized() {
    final frequencyInMilis = localStorage.read<int>(
      durationMillisecondsFrequencyKey,
    );

    if (frequencyInMilis == null) {
      throw const NotInitialisedInAppReviewException();
    }
  }

  /// Get the configured frequency duration
  Duration _getFrequencyDuration() {
    final frequencyInMilis =
        localStorage.read<int>(durationMillisecondsFrequencyKey) ??
        const Duration(days: 30).inMilliseconds;

    return Duration(milliseconds: frequencyInMilis);
  }

  /// Show the review prompt and handle tracking
  Future<void> _showReviewPrompt({bool ignoreFrequency = false}) async {
    final nowUtc = getCurrentTime();

    // Increment the prompt count
    final currentCount = localStorage.read<int>(reviewPromptCountKey) ?? 0;
    await localStorage.write(reviewPromptCountKey, currentCount + 1);

    // Update the last review timestamp
    await localStorage.write(lastReviewDateTimeKey, nowUtc.toIso8601String());

    // Show the actual review prompt
    await inAppReview.requestReview().then((_) async {
      // Track the event
      await analytics?.logEvent(
        analyticsEvent: FirebaseAnalyticsEvent(
          name: 'app_review_prompted',
          parameters: {
            'prompt_count': currentCount + 1,
            'was_shown': true,
            'forced': ignoreFrequency,
          },
        ),
      );
    });

    logger.i('InAppReview prompt shown (count: ${currentCount + 1})');
  }
}
