import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class FloatingActionButtonThemes {
  static FloatingActionButtonThemeData light() => FloatingActionButtonThemeData(
        backgroundColor:
            AppSemanticColors.light.backgroundBrand, // Default FAB background
        foregroundColor: AppSemanticColors
            .light.contentInversed, // Default FAB icon/text color
      );

  static FloatingActionButtonThemeData dark() => FloatingActionButtonThemeData(
        backgroundColor:
            AppSemanticColors.dark.backgroundBrand, // Default FAB background
        foregroundColor: AppSemanticColors
            .dark.contentInversed, // Default FAB icon/text color
      );
}
