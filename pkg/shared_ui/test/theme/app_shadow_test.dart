import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_effect_styles.dart';
import 'package:shared_ui/theme/app_shadow.dart';

void main() {
  group('AppShadow', () {
    test('levels reference AppEffectStyles pairs', () {
      expect(AppShadow.l1, [
        AppEffectStyles.shadowL1Effect0,
        AppEffectStyles.shadowL1Effect1,
      ]);
      expect(AppShadow.l2, [
        AppEffectStyles.shadowL2Effect0,
        AppEffectStyles.shadowL2Effect1,
      ]);
      expect(AppShadow.l3, [
        AppEffectStyles.shadowL3Effect0,
        AppEffectStyles.shadowL3Effect1,
      ]);
      expect(AppShadow.l4, [
        AppEffectStyles.shadowL4Effect0,
        AppEffectStyles.shadowL4Effect1,
      ]);
      expect(AppShadow.l5, [
        AppEffectStyles.shadowL5Effect0,
        AppEffectStyles.shadowL5Effect1,
      ]);
      expect(AppShadow.l6, [
        AppEffectStyles.shadowL6Effect0,
        AppEffectStyles.shadowL6Effect1,
      ]);
    });
  });
}
