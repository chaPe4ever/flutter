import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class TimePickerThemes {
  static TimePickerThemeData light() {
    return TimePickerThemeData(
      backgroundColor: AppSemanticColors.light.contentInversed,
      dialBackgroundColor: AppSemanticColors.light.backgroundInversed,
      dialTextColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.light.contentInversed
            : AppSemanticColors.light.contentPrimary,
      ),
      cancelButtonStyle: TextButton.styleFrom(
        textStyle: AppTextTheme.light().textStyles.bodyL,
      ),
      confirmButtonStyle: TextButton.styleFrom(
        textStyle: AppTextTheme.light().textStyles.bodyL,
      ),
    );
  }

  static TimePickerThemeData dark() {
    return TimePickerThemeData(
      backgroundColor: AppSemanticColors.dark.contentInversed,
      dialBackgroundColor: AppSemanticColors.dark.backgroundInversed,
      dialTextColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.dark.contentInversed
            : AppSemanticColors.dark.contentPrimary,
      ),
      cancelButtonStyle: TextButton.styleFrom(
        textStyle: AppTextTheme.dark().textStyles.bodyL,
      ),
      confirmButtonStyle: TextButton.styleFrom(
        textStyle: AppTextTheme.dark().textStyles.bodyL,
      ),
    );
  }
}
