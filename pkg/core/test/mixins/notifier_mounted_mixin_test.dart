import 'package:core/mixins/notifier_mounted_mixin.dart';
import 'package:flutter_test/flutter_test.dart';

final class _MountedProbe with NotifierMountedMixin {}

void main() {
  group('NotifierMountedMixin', () {
    test('starts mounted and becomes unmounted after setUnmounted', () {
      final probe = _MountedProbe();

      expect(probe.mounted, isTrue);

      probe.setUnmounted();

      expect(probe.mounted, isFalse);
    });
  });
}
