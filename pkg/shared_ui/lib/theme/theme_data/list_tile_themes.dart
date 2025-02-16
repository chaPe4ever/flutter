import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ListTileThemes {
  static ListTileThemeData light() {
    return ListTileThemeData(
      titleTextStyle: AppTextTheme.light().textStyles.titleL,
      subtitleTextStyle: AppTextTheme.light().textStyles.bodyM,
    );
  }

  static ListTileThemeData dark() {
    return ListTileThemeData(
      titleTextStyle: AppTextTheme.dark().textStyles.titleL,
      subtitleTextStyle: AppTextTheme.dark().textStyles.bodyM,
    );
  }
}
