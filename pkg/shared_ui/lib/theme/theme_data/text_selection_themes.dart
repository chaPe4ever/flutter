import 'package:flutter/material.dart';
import 'package:shared_ui/theme/pallete/app_semantic_colors.dart';

class TextSelectionThemes {
  static TextSelectionThemeData light() {
    return TextSelectionThemeData(
      selectionColor: AppSemanticColors.light.contentPrimary,
    );
  }

  static TextSelectionThemeData dark() {
    return TextSelectionThemeData(
      selectionColor: AppSemanticColors.dark.contentPrimary,
    );
  }
}
