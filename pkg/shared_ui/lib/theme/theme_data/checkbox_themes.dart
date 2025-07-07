import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class CheckboxThemes {
  static CheckboxThemeData light() {
    return CheckboxThemeData(
      checkColor: WidgetStateProperty.all(
        AppSemanticColors.light.backgroundPrimary,
      ),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.dark.backgroundBrand
            : AppSemanticColors.light.backgroundPrimary,
      ),
      overlayColor: WidgetStateProperty.all(
        AppSemanticColors.light.backgroundPrimary,
      ),
    );
  }

  static CheckboxThemeData dark() {
    return CheckboxThemeData(
      checkColor: WidgetStateProperty.all(
        AppSemanticColors.dark.backgroundInversed,
      ),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.dark.backgroundBrand
            : AppSemanticColors.dark.backgroundPrimary,
      ),
      overlayColor: WidgetStateProperty.all(
        AppSemanticColors.dark.backgroundPrimary,
      ),
    );
  }
}
