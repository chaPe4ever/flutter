import 'package:analytics/analytics.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inapp_review/implementations/in_app_review_service_impl.dart';
import 'package:inapp_review/pods/in_app_review.dart';
import 'package:inapp_review/pods/in_app_review_service.dart';

import '../shared/in_app_review_test_doubles.dart';

void main() {
  test('inAppReviewServicePod wires InAppReviewServiceImpl dependencies', () {
    final inAppReview = FakeInAppReview();
    final localStorage = FakeLocalStorage();
    final network = FakeNetwork();
    final logger = FakeLogger();
    final analytics = FakeAnalytics();

    final container = ProviderContainer(
      overrides: [
        inAppReviewPod.overrideWithValue(inAppReview),
        localStoragePod.overrideWithValue(localStorage),
        networkPod.overrideWithValue(network),
        loggerPod.overrideWithValue(logger),
        analyticsPod.overrideWithValue(analytics),
      ],
    );
    addTearDown(container.dispose);

    final service = container.read(inAppReviewServicePod);

    expect(service, isA<InAppReviewServiceImpl>());
  });
}
