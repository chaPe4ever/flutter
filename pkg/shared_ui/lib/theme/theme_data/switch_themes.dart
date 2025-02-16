import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SwitchThemes {
  static SwitchThemeData light() {
    return SwitchThemeData(
      trackOutlineColor:
          WidgetStateProperty.all(AppSemanticColors.light.backgroundDisabled),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.light.contentBrand
            : AppSemanticColors.light.contentPressed,
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.light.backgroundPrimary
            : AppSemanticColors.light.backgroundDisabled,
      ),
    );
  }

  static SwitchThemeData dark() {
    return SwitchThemeData(
      trackOutlineColor:
          WidgetStateProperty.all(AppSemanticColors.dark.backgroundDisabled),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.dark.contentBrand
            : AppSemanticColors.dark.contentPressed,
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.dark.backgroundInversed
            : AppSemanticColors.dark.backgroundDisabled,
      ),
    );
  }
}
