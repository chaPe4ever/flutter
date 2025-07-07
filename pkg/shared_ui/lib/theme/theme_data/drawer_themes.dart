import 'package:flutter/material.dart';
import 'package:shared_ui/theme/pallete/app_semantic_colors.dart';

class DrawerThemes {
  static DrawerThemeData light() => DrawerThemeData(
    backgroundColor: AppSemanticColors.light.backgroundPrimary,
    surfaceTintColor: Colors.transparent,
  );

  static DrawerThemeData dark() => DrawerThemeData(
    backgroundColor: AppSemanticColors.dark.backgroundPrimary,
    surfaceTintColor: Colors.transparent,
  );
}
