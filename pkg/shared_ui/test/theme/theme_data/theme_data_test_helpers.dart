import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_theme.dart';

const Set<WidgetState> emptyWidgetStates = <WidgetState>{};
const Set<WidgetState> hoveredWidgetStates = {WidgetState.hovered};
const Set<WidgetState> pressedWidgetStates = {WidgetState.pressed};
const Set<WidgetState> selectedWidgetStates = {WidgetState.selected};
const Set<WidgetState> errorWidgetStates = {WidgetState.error};
const Set<WidgetState> focusedWidgetStates = {WidgetState.focused};
const Set<WidgetState> disabledWidgetStates = {WidgetState.disabled};

void resolveWidgetStateColor(Color? color, Set<WidgetState> states) {
  if (color is WidgetStateColor) {
    color.resolve(states);
  }
}

void resolveWidgetStateTextStyle(TextStyle? style, Set<WidgetState> states) {
  if (style is WidgetStateTextStyle) {
    style.resolve(states);
  }
}

/// Resolves widget-state-driven sub-themes on [ThemeData] as wired by
/// [AppTheme].
void resolveAppThemeWidgetStates(ThemeData theme) {
  theme.textButtonTheme.style?.backgroundColor?.resolve(hoveredWidgetStates);
  theme.textButtonTheme.style?.backgroundColor?.resolve(emptyWidgetStates);
  theme.elevatedButtonTheme.style?.elevation?.resolve(pressedWidgetStates);
  theme.elevatedButtonTheme.style?.elevation?.resolve(emptyWidgetStates);
  theme.filledButtonTheme.style?.elevation?.resolve(pressedWidgetStates);
  theme.filledButtonTheme.style?.elevation?.resolve(emptyWidgetStates);

  theme.checkboxTheme.fillColor?.resolve(selectedWidgetStates);
  theme.checkboxTheme.fillColor?.resolve(emptyWidgetStates);
  theme.switchTheme.trackColor?.resolve(selectedWidgetStates);
  theme.switchTheme.trackColor?.resolve(emptyWidgetStates);
  theme.switchTheme.thumbColor?.resolve(selectedWidgetStates);
  theme.switchTheme.thumbColor?.resolve(emptyWidgetStates);

  theme.datePickerTheme.dayForegroundColor?.resolve(selectedWidgetStates);
  theme.datePickerTheme.dayForegroundColor?.resolve(emptyWidgetStates);

  theme.navigationBarTheme.iconTheme?.resolve(selectedWidgetStates);
  theme.navigationBarTheme.iconTheme?.resolve(emptyWidgetStates);
  theme.navigationBarTheme.labelTextStyle?.resolve(selectedWidgetStates);
  theme.navigationBarTheme.labelTextStyle?.resolve(emptyWidgetStates);

  theme.dropdownMenuTheme.menuStyle?.side?.resolve(errorWidgetStates);
  theme.dropdownMenuTheme.menuStyle?.side?.resolve(emptyWidgetStates);

  theme.searchBarTheme.backgroundColor?.resolve(emptyWidgetStates);
  theme.searchBarTheme.overlayColor?.resolve(emptyWidgetStates);
  theme.searchBarTheme.surfaceTintColor?.resolve(emptyWidgetStates);

  resolveWidgetStateColor(
    theme.snackBarTheme.backgroundColor,
    emptyWidgetStates,
  );
  resolveWidgetStateColor(
    theme.snackBarTheme.actionTextColor,
    emptyWidgetStates,
  );
  resolveWidgetStateColor(
    theme.timePickerTheme.dialTextColor,
    selectedWidgetStates,
  );
  resolveWidgetStateColor(
    theme.timePickerTheme.dialTextColor,
    emptyWidgetStates,
  );

  resolveWidgetStateTextStyle(
    theme.inputDecorationTheme.floatingLabelStyle,
    errorWidgetStates,
  );
  resolveWidgetStateTextStyle(
    theme.inputDecorationTheme.floatingLabelStyle,
    focusedWidgetStates,
  );
  resolveWidgetStateTextStyle(
    theme.inputDecorationTheme.floatingLabelStyle,
    disabledWidgetStates,
  );
  resolveWidgetStateTextStyle(
    theme.inputDecorationTheme.floatingLabelStyle,
    emptyWidgetStates,
  );
  resolveWidgetStateTextStyle(
    theme.dropdownMenuTheme.inputDecorationTheme?.floatingLabelStyle,
    errorWidgetStates,
  );
  resolveWidgetStateTextStyle(
    theme.dropdownMenuTheme.inputDecorationTheme?.floatingLabelStyle,
    focusedWidgetStates,
  );
  resolveWidgetStateTextStyle(
    theme.dropdownMenuTheme.inputDecorationTheme?.floatingLabelStyle,
    disabledWidgetStates,
  );
  resolveWidgetStateTextStyle(
    theme.dropdownMenuTheme.inputDecorationTheme?.floatingLabelStyle,
    emptyWidgetStates,
  );
}
