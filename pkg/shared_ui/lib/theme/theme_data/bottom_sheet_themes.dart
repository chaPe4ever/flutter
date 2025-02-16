import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class BottomSheetThemes {
  static BottomSheetThemeData light() {
    return BottomSheetThemeData(
      dragHandleColor: AppSemanticColors.light.contentSecondary,
      showDragHandle: true,
      backgroundColor: AppSemanticColors.light.backgroundPrimary,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: AppRadius.l,
        ),
      ),
    );
  }

  static BottomSheetThemeData dark() {
    return BottomSheetThemeData(
      dragHandleColor: AppSemanticColors.light.contentSecondary,
      showDragHandle: true,
      backgroundColor: AppSemanticColors.dark.backgroundPrimary,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: AppRadius.l,
        ),
      ),
    );
  }
}
