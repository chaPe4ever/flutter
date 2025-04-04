import 'package:analytics/pods/analytics_pod.dart';
import 'package:core/core.dart';
import 'package:inapp_review/contracts/in_app_review_service_base.dart';
import 'package:inapp_review/exceptions/in_app_review_exceptions.dart';
import 'package:inapp_review/implementations/in_app_review_service_impl.dart';
import 'package:inapp_review/pods/in_app_review.dart';

part 'in_app_review_service.g.dart';

/// Provider for the InAppReviewService
@riverpod
class InAppReviewService extends _$InAppReviewService {
  @override
  InAppReviewServiceBase build() {
    final logger = ref.read(loggerPod);
    final localStorage = ref.read(localStoragePod);
    if (!localStorage.hasValue) {
      logger.e(
        'LocalStorage not initialized, make sure it is initialized before using'
        ' InAppReviewService',
      );
      throw const NotInitialisedInAppReviewException();
    }

    // Create and return the implementation
    return InAppReviewServiceImpl(
      inAppReview: ref.read(inAppReviewPod),
      localStorage: localStorage.requireValue,
      network: ref.read(networkPod),
      logger: logger,
      analytics: ref.read(analyticsPod),
    );
  }
}
