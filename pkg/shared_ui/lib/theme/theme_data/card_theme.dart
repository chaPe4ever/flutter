import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class CardThemes {
  static CardThemeData light() {
    return CardThemeData(
      shadowColor: AppSemanticColors.light.overlay50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadius.xs),
      ),
      color: AppSemanticColors.light.backgroundPrimary,
    );
  }

  static CardThemeData dark() {
    return CardThemeData(
      shadowColor: AppSemanticColors.light.overlay50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadius.xs),
      ),
      color: AppSemanticColors.dark.backgroundPrimary,
    );
  }
}
