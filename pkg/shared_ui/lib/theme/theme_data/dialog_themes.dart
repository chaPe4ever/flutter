import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class DialogThemes {
  static DialogThemeData light() {
    return DialogThemeData(
      backgroundColor: AppSemanticColors.light.backgroundPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadius.l),
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.contentL),
      alignment: Alignment.center,
    );
  }

  static DialogThemeData dark() {
    return DialogThemeData(
      backgroundColor: AppSemanticColors.dark.backgroundPrimary,
      barrierColor: AppSemanticColors.dark.overlay50Inverse.withOpacity(0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadius.l),
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.contentL),
      insetPadding: const EdgeInsets.all(AppSpacing.contentL),
      alignment: Alignment.center,
    );
  }
}
