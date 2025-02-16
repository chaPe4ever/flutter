import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SearchbarThemes {
  static SearchBarThemeData light() {
    final ts = AppTextTheme.light().textStyles;

    return SearchBarThemeData(
      backgroundColor: WidgetStateColor.resolveWith((states) {
        return AppSemanticColors.light.backgroundSelected;
      }),
      overlayColor: WidgetStateColor.resolveWith((states) {
        return AppSemanticColors.light.backgroundSelected;
      }),
      surfaceTintColor: WidgetStateColor.resolveWith((states) {
        return AppSemanticColors.light.backgroundSelected;
      }),
      hintStyle: WidgetStateProperty.all(
        ts.bodyL.copyWith(
          color: AppSemanticColors.light.contentDisabled,
        ),
      ),
      textStyle: WidgetStateProperty.all(
        ts.bodyM,
      ),
    );
  }

  static SearchBarThemeData dark() {
    final ts = AppTextTheme.dark().textStyles;

    return SearchBarThemeData(
      backgroundColor: WidgetStateColor.resolveWith((states) {
        return AppSemanticColors.dark.backgroundSelected;
      }),
      overlayColor: WidgetStateColor.resolveWith((states) {
        return AppSemanticColors.dark.backgroundSelected;
      }),
      surfaceTintColor: WidgetStateColor.resolveWith((states) {
        return AppSemanticColors.dark.backgroundSelected;
      }),
      hintStyle: WidgetStateProperty.all(
        ts.bodyL.copyWith(
          color: AppSemanticColors.dark.contentDisabled,
        ),
      ),
      textStyle: WidgetStateProperty.all(
        ts.bodyM,
      ),
    );
  }
}
