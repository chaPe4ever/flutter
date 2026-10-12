import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_effect_styles.dart';
import 'package:shared_ui/theme/pallete/app_primitive_colors.dart';

void main() {
  group('AppEffectStyles', () {
    test('shadows and gradients are defined', () {
      expect(AppEffectStyles.shadowL1Effect0.blurRadius, 2);
      expect(AppEffectStyles.shadowL1Effect1.offset, const Offset(0, 2));
      expect(AppEffectStyles.shadowL2Effect0.blurRadius, 4);
      expect(AppEffectStyles.shadowL3Effect1.blurRadius, 16);
      expect(AppEffectStyles.shadowL4Effect1.offset, const Offset(0, 10));
      expect(AppEffectStyles.shadowL5Effect0.blurRadius, 10);
      expect(AppEffectStyles.shadowL6Effect1.blurRadius, 32);
      expect(
        AppEffectStyles.redLinearGradient.colors,
        [
          AppPrimitiveColors.baseBrownRegular,
          AppPrimitiveColors.baseRedDark,
        ],
      );
      expect(
        AppEffectStyles.blueLinearGradient.colors,
        [
          AppPrimitiveColors.baseBlueRegular,
          AppPrimitiveColors.baseBlueLight,
        ],
      );
    });
  });
}
