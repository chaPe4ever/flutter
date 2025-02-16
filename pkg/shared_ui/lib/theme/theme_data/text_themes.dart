import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class TextThemes {
  static final _tsLight = AppTextTheme.light().textStyles;
  static final _tsDark = AppTextTheme.dark().textStyles;

  static TextTheme light() {
    return TextTheme(
      headlineLarge: _tsLight.headlineL,
      headlineMedium: _tsLight.headlineM,
      headlineSmall: _tsLight.headlineS,
      titleLarge: _tsLight.titleL,
      titleMedium: _tsLight.titleM,
      bodyLarge: _tsLight.bodyL,
      bodyMedium: _tsLight.bodyM,
      bodySmall: _tsLight.bodyS,
      labelLarge: _tsLight.labelL,
      labelMedium: _tsLight.labelM,
    );
  }

  static TextTheme dark() {
    return TextTheme(
      headlineLarge: _tsDark.headlineL,
      headlineMedium: _tsDark.headlineM,
      headlineSmall: _tsDark.headlineS,
      titleLarge: _tsDark.titleL,
      titleMedium: _tsDark.titleM,
      bodyLarge: _tsDark.bodyL,
      bodyMedium: _tsDark.bodyM,
      bodySmall: _tsDark.bodyS,
      labelLarge: _tsDark.labelL,
      labelMedium: _tsDark.labelM,
    );
  }
}
