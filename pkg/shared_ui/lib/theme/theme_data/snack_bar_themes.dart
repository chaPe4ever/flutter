import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SnackBarThemes {
  static final tsL = AppTextTheme.light().textStyles;
  static final tsD = AppTextTheme.dark().textStyles;
  static const colorsL = AppSemanticColors.light;
  static const colorsD = AppSemanticColors.dark;

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
