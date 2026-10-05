import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SnackBarThemes {
  static final PlatformTextStyles tsL = AppTextTheme.light().textStyles;
  static final PlatformTextStyles tsD = AppTextTheme.dark().textStyles;
  static const SemanticColors colorsL = AppSemanticColors.light;
  static const SemanticColors colorsD = AppSemanticColors.dark;

  static SnackBarThemeData light() {
    return SnackBarThemeData(
      backgroundColor: WidgetStateColor.resolveWith((states) {
        return colorsD.backgroundFocused;
      }),
      actionTextColor: WidgetStateColor.resolveWith((states) {
        return colorsL.contentLinkHover;
      }),
    );
  }

  static SnackBarThemeData dark() {
    return SnackBarThemeData(
      backgroundColor: WidgetStateColor.resolveWith((states) {
        return colorsD.backgroundFocused;
      }),
      actionTextColor: WidgetStateColor.resolveWith((states) {
        return colorsL.contentLinkHover;
      }),
    );
  }
}
