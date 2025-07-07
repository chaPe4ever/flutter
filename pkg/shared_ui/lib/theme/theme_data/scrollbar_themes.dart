import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ScrollbarThemes {
  static ScrollbarThemeData light() {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(
        AppSemanticColors.light.backgroundDisabled,
      ),
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(AppSpacing.contentXS),
      radius: AppRadius.pill,
    );
  }

  static ScrollbarThemeData dark() {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(
        AppSemanticColors.dark.backgroundDisabled,
      ),
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(AppSpacing.contentXS),
      radius: AppRadius.pill,
    );
  }
}
