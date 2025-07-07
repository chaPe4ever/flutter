import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class DatePickerThemes {
  static DatePickerThemeData light() {
    return DatePickerThemeData(
      dayStyle: AppTextTheme.light().textStyles.titleL,
      weekdayStyle: AppTextTheme.light().textStyles.titleL,
      dayForegroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.light.backgroundPrimary
            : AppSemanticColors.light.backgroundBrand,
      ),
      dayBackgroundColor: WidgetStatePropertyAll(
        AppSemanticColors.light.backgroundBrand,
      ),
    );
  }

  static DatePickerThemeData dark() {
    return DatePickerThemeData(
      dayStyle: AppTextTheme.dark().textStyles.titleL,
      weekdayStyle: AppTextTheme.dark().textStyles.titleL,
      dayForegroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppSemanticColors.dark.backgroundPrimary
            : AppSemanticColors.dark.backgroundBrand,
      ),
      dayBackgroundColor: WidgetStatePropertyAll(
        AppSemanticColors.dark.backgroundBrand,
      ),
    );
  }
}
