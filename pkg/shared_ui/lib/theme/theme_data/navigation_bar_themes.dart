import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class NavigationBarThemes {
  static NavigationBarThemeData get light => NavigationBarThemeData(
        backgroundColor: AppSemanticColors.light.backgroundPrimary,
        indicatorColor: AppSemanticColors.light.contentPressed,
        surfaceTintColor: AppSemanticColors.light.backgroundPrimary,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemes.light().copyWith(
              color: AppSemanticColors.light.contentBrand,
            );
          }
          return IconThemes.light().copyWith(
            color: AppSemanticColors.light.backgroundDisabled,
          );
        }),
        labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextTheme.light().textStyles.bodyM.copyWith(
                  color: AppSemanticColors.light.contentPrimary,
                );
          }
          return AppTextTheme.light().textStyles.bodyM.copyWith(
                color: AppSemanticColors.light.backgroundDisabled,
              );
        }),
      );

  static NavigationBarThemeData get dark => NavigationBarThemeData(
        backgroundColor: AppSemanticColors.dark.backgroundPrimary,
        indicatorColor: AppSemanticColors.dark.contentPressed,
        surfaceTintColor: AppSemanticColors.dark.backgroundPrimary,
        labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextTheme.dark().textStyles.bodyM.copyWith(
                  color: AppSemanticColors.dark.contentPrimary,
                );
          }
          return AppTextTheme.dark().textStyles.bodyM.copyWith(
                color: AppSemanticColors.dark.backgroundDisabled,
              );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemes.dark().copyWith(
              color: AppSemanticColors.dark.contentBrand,
            );
          }
          return IconThemes.dark().copyWith(
            color: AppSemanticColors.dark.backgroundDisabled,
          );
        }),
      );
}
