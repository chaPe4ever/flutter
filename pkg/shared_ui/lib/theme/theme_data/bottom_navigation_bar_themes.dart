import 'package:flutter/material.dart';
import 'package:shared_ui/theme/pallete/app_semantic_colors.dart';

class BottomNavigationBarThemes {
  static BottomNavigationBarThemeData light() => BottomNavigationBarThemeData(
        selectedItemColor: AppSemanticColors.light.backgroundPressed,
        backgroundColor: AppSemanticColors.light.backgroundPressed,
      );

  static BottomNavigationBarThemeData dark() => BottomNavigationBarThemeData(
        selectedItemColor: AppSemanticColors.dark.backgroundPressed,
        backgroundColor: AppSemanticColors.dark.backgroundPressed,
      );
}
