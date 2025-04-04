/// Abstract interface for the in-app review service
///
/// This service handles prompting users to review the app according to
/// specific timing strategies and best practices. It complies with
/// platform-specific guidelines for app reviews.
abstract interface class InAppReviewServiceBase {
  /// Initialize the in-app review service with configuration
  ///
  /// [frequency] - How often to show the review prompt (defaults to 30 days)
  /// [maxPrompts] - Maximum number of times to show the prompt (defaults to 3)
  Future<void> init({
    Duration frequency = const Duration(days: 30),
    int maxPrompts = 1000,
  });

  /// Reset the timer for when the next review prompt can be shown
  Future<void> resetShowFrequency();

  /// Show the review prompt if all conditions are met:
  /// - Service is initialized
  /// - Network is available
  /// - In-app review is supported on device
  /// - Enough time has passed since last prompt
  /// - Maximum number of prompts not exceeded
  Future<void> show();

  /// Check if a review can be shown without actually showing it
  Future<bool> canShowReview();

  /// Force show the review dialog regardless of timing constraints
  /// Only checks for device support and network availability
  Future<void> forceShow();

  /// Open the store page for the app as a fallback
  /// [appStoreId] is required for iOS and MacOS
  /// [microsoftStoreId] is required for Windows
  Future<void> openStoreReview({String? appStoreId, String? microsoftStoreId});

  /// Mark that user has provided a review
  /// This can be used to stop showing the prompt altogether
  Future<void> markReviewCompleted();

  /// Get the number of times the review prompt has been shown
  Future<int> getPromptCount();
}
