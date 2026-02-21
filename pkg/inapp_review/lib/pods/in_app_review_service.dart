import 'package:analytics/analytics.dart';
import 'package:core/core.dart';
import 'package:inapp_review/contracts/in_app_review_service_base.dart';
import 'package:inapp_review/implementations/in_app_review_service_impl.dart';
import 'package:inapp_review/pods/in_app_review.dart';

part 'in_app_review_service.g.dart';

/// Provider for the InAppReviewService
@riverpod
class InAppReviewService extends _$InAppReviewService {
  @override
  InAppReviewServiceBase build() {
    // Create and return the implementation
    return InAppReviewServiceImpl(
      inAppReview: ref.read(inAppReviewPod),
      localStorage: ref.read(localStoragePod),
      network: ref.read(networkPod),
      logger: ref.read(loggerPod),
      analytics: ref.read(analyticsPod),
    );
  }
}
