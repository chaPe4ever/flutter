import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ButtonThemes {
  static const Duration _animationDuration = Duration(milliseconds: 260);

  static const Size _minimumButtonSize = Size(
    AppSpacing.sectionS,
    AppSpacing.sectionS,
  );
  static const EdgeInsets _padding = EdgeInsets.all(AppSpacing.contentXL);

  static const BorderRadius _borderRadius = BorderRadius.all(
    AppRadius.xs,
  );

  static IconButtonThemeData iconLight() {
    return const IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }

  static IconButtonThemeData iconDark() {
    return const IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }

  static TextButtonThemeData textLight() {
    return TextButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              AppRadius.xs,
            ),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textStyle: WidgetStateProperty.all(
          TextThemes.light().bodyLarge?.copyWith(
            color: AppSemanticColors.light.contentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        animationDuration: _animationDuration,
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppSemanticColors.light.backgroundHovered;
          }
          return AppSemanticColors.light.backgroundPrimary;
        }),
      ),
    );
  }

  static TextButtonThemeData textDark() {
    return TextButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              AppRadius.xs,
            ),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textStyle: WidgetStateProperty.all(
          TextThemes.light().bodyLarge?.copyWith(
            color: AppSemanticColors.dark.contentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        animationDuration: _animationDuration,
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppSemanticColors.dark.backgroundHovered;
          }
          return AppSemanticColors.dark.backgroundPrimary;
        }),
      ),
    );
  }

  static ElevatedButtonThemeData elevatedLight() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: _borderRadius),
        ),
        textStyle: WidgetStateProperty.all(
          TextThemes.light().bodyLarge?.copyWith(
            color: AppSemanticColors.light.contentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_padding),
        animationDuration: _animationDuration,
        minimumSize: WidgetStateProperty.all(_minimumButtonSize),
        shadowColor: WidgetStateProperty.all(AppSemanticColors.light.overlay50),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return 0;
          } else {
            return 2;
          }
        }),
      ),
    );
  }

  static ElevatedButtonThemeData elevatedDark() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: _borderRadius),
        ),
        textStyle: WidgetStateProperty.all(
          TextThemes.dark().bodyLarge?.copyWith(
            color: AppSemanticColors.dark.contentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_padding),
        animationDuration: _animationDuration,
        minimumSize: WidgetStateProperty.all(_minimumButtonSize),
        shadowColor: WidgetStateProperty.all(AppSemanticColors.dark.overlay50),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return 0;
          } else {
            return 2;
          }
        }),
      ),
    );
  }

  static FilledButtonThemeData filledLight() {
    return FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: _borderRadius),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: AppSemanticColors.light.borderPrimary,
            width: AppBorderWidth.s,
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_padding),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        shadowColor: WidgetStateProperty.all(AppSemanticColors.light.overlay50),
        textStyle: WidgetStateProperty.all(
          TextThemes.light().bodyLarge?.copyWith(
            color: AppSemanticColors.light.contentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        animationDuration: _animationDuration,
        overlayColor: WidgetStatePropertyAll(AppSemanticColors.light.overlay50),
        minimumSize: WidgetStateProperty.all(_minimumButtonSize),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return 0;
          } else {
            return 2;
          }
        }),
      ),
    );
  }

  static FilledButtonThemeData filledDark() {
    return FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: _borderRadius),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: AppSemanticColors.dark.borderPrimary,
            width: AppBorderWidth.s,
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_padding),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        shadowColor: WidgetStateProperty.all(AppSemanticColors.dark.overlay50),
        textStyle: WidgetStateProperty.all(
          TextThemes.light().bodyLarge?.copyWith(
            color: AppSemanticColors.light.contentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        animationDuration: _animationDuration,
        overlayColor: WidgetStatePropertyAll(AppSemanticColors.dark.overlay50),
        minimumSize: WidgetStateProperty.all(_minimumButtonSize),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return 0;
          } else {
            return 2;
          }
        }),
      ),
    );
  }

  static OutlinedButtonThemeData outlinedLight() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: _borderRadius),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: AppSemanticColors.light.borderPrimary,
            width: AppBorderWidth.s,
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_padding),
        minimumSize: WidgetStateProperty.all(_minimumButtonSize),
        textStyle: WidgetStateProperty.all(
          TextThemes.light().bodyLarge?.copyWith(
            color: AppSemanticColors.light.contentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        animationDuration: _animationDuration,
      ),
    );
  }

  static OutlinedButtonThemeData outlinedDark() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: _borderRadius),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: AppSemanticColors.dark.borderPrimary,
            width: AppBorderWidth.s,
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_padding),
        minimumSize: WidgetStateProperty.all(_minimumButtonSize),
        textStyle: WidgetStateProperty.all(
          TextThemes.light().bodyLarge?.copyWith(
            color: AppSemanticColors.dark.contentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        animationDuration: _animationDuration,
      ),
    );
  }
}
