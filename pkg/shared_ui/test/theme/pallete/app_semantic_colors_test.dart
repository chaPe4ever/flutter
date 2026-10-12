import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/pallete/app_primitive_colors.dart';
import 'package:shared_ui/theme/pallete/app_semantic_colors.dart';

void main() {
  test('light and dark palettes expose expected brand colors', () {
    expect(
      AppSemanticColors.light.backgroundBrand,
      AppPrimitiveColors.basePurpleRegular,
    );
    expect(
      AppSemanticColors.light.backgroundPrimary,
      AppPrimitiveColors.baseWhiteRegular,
    );
    expect(
      AppSemanticColors.dark.backgroundPrimary,
      AppPrimitiveColors.baseBlackRegular,
    );
    expect(
      AppSemanticColors.dark.contentTabBarSelected,
      AppPrimitiveColors.basePurpleLight,
    );
    expect(AppSemanticColors.light.surface, isA<Color>());
    expect(AppSemanticColors.dark.contentInversed, isA<Color>());
  });
}
