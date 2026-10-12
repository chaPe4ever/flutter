import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:inapp_review/pods/in_app_review.dart';

void main() {
  test('inAppReviewPod exposes the platform singleton', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(inAppReviewPod), same(InAppReview.instance));
  });
}
