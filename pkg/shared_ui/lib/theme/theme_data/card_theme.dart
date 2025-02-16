import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class CardThemes {
  static CardTheme light() {
    return CardTheme(
      shadowColor: AppSemanticColors.light.overlay50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadius.xs),
      ),
      color: AppSemanticColors.light.backgroundPrimary,
    );
  }

  static CardTheme dark() {
    return CardTheme(
      shadowColor: AppSemanticColors.light.overlay50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadius.xs),
      ),
      color: AppSemanticColors.dark.backgroundPrimary,
    );
  }
}
