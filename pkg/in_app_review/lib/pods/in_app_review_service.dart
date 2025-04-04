import 'package:analytics/pods/analytics_pod.dart';
import 'package:core/core.dart';
import 'package:in_app_rewiew/contracts/in_app_review_service_base.dart';
import 'package:in_app_rewiew/implementations/in_app_review_service_impl.dart';
import 'package:in_app_rewiew/pods/in_app_review.dart';

part 'in_app_review_service.g.dart';

/// Provider for the InAppReviewService
@riverpod
class InAppReviewService extends _$InAppReviewService {
  @override
  FutureOr<InAppReviewServiceBase> build() async {
    // Wait for localStorage if needed
    if (!ref.read(localStoragePod).hasValue) {
      await ref.read(localStoragePod.future);
    }

    // Create and return the implementation
    return InAppReviewServiceImpl(
      inAppReview: ref.read(inAppReviewPod),
      localStorage: ref.read(localStoragePod).requireValue,
      network: ref.read(networkPod),
      logger: ref.read(loggerPod),
      analytics: ref.read(analyticsPod),
    );
  }

  /// Initialize the service with custom configuration
  Future<void> init({
    Duration frequency = const Duration(days: 30),
    int maxPrompts = 1000,
  }) async {
    final service = await future;
    await service.init(frequency: frequency, maxPrompts: maxPrompts);
  }
}
