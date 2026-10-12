import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderContainer makeProviderContainer({
  List<Override>? overrides,
  bool isTearDownActive = true,
  Duration? Function(int retryCount, Object error)? retry,
}) {
  final container = retry == null
      ? ProviderContainer(overrides: overrides ?? [])
      : ProviderContainer(overrides: overrides ?? [], retry: retry);
  if (isTearDownActive) {
    addTearDown(container.dispose);
  }
  return container;
}
