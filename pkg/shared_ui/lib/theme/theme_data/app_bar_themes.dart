import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AppBarThemes {
  static AppBarTheme light() {
    return AppBarTheme(
      backgroundColor: AppSemanticColors.light.backgroundPrimary,
      surfaceTintColor: AppSemanticColors.light.backgroundPrimary,
      iconTheme: IconThemeData(
        color: AppSemanticColors.light.backgroundBrand,
      ),
      titleSpacing: 2,
      elevation: 0,
      scrolledUnderElevation: 2,
      // shape: Border(
      //   bottom: BorderSide(
      //     color: AppSemanticColors.light.borderBrand,
      //     width: AppBorderWidth.s,
      //   ),
      // ),
    );
  }

  static AppBarTheme dark() {
    return AppBarTheme(
      backgroundColor: AppSemanticColors.dark.backgroundPrimary,
      surfaceTintColor: AppSemanticColors.dark.backgroundPrimary,
      iconTheme: IconThemeData(
        color: AppSemanticColors.dark.backgroundBrand,
      ),
      titleSpacing: 2,
      elevation: 0,
      scrolledUnderElevation: 2,
      // shape: Border(
      //   bottom: BorderSide(
      //     color: AppSemanticColors.dark.borderBrand,
      //     width: AppBorderWidth.s,
      //   ),
      // ),
    );
  }
}
