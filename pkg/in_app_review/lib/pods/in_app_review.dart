import 'package:core/core.dart';
import 'package:in_app_review/in_app_review.dart';

part 'in_app_review.g.dart';

/// Provider for InAppReview instance
@Riverpod(keepAlive: true)
InAppReview inAppReview(Ref ref) {
  return InAppReview.instance;
}
