import 'package:flutter_test/flutter_test.dart';
import 'package:inapp_review/contracts/in_app_review_service_base.dart';
import 'package:inapp_review/implementations/in_app_review_service_impl.dart';

import '../shared/in_app_review_test_doubles.dart';

void main() {
  test('InAppReviewServiceImpl satisfies InAppReviewServiceBase', () {
    final service = InAppReviewServiceImpl(
      inAppReview: FakeInAppReview(),
      localStorage: FakeLocalStorage(),
      network: FakeNetwork(),
      logger: FakeLogger(),
    );

    expect(service, isA<InAppReviewServiceBase>());
  });
}
