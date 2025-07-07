import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class InputDecorationThemes {
  static const colorsL = AppSemanticColors.light;
  static const colorsD = AppSemanticColors.dark;
  static final tsL = AppTextTheme.light().textStyles;
  static final tsD = AppTextTheme.dark().textStyles;

  static InputDecorationTheme light() => InputDecorationTheme(
    helperMaxLines: 1,
    errorMaxLines: 1,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: colorsL.borderSupport),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorsL.borderDisabled),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorsL.borderFocused),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorsL.contentNegative),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: colorsL.contentNegative),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorsL.borderDisabled),
    ),
    focusColor: colorsL.contentBrand,
    hoverColor: colorsL.borderHovered,
    fillColor: colorsL.backgroundPrimary,
    hintStyle: tsL.titleL.copyWith(
      color: colorsL.contentTertiary,
    ),
    errorStyle: tsL.bodyS.copyWith(
      color: colorsL.contentNegative,
    ),
    labelStyle: tsL.bodyS.copyWith(
      color: colorsL.contentPrimary,
    ),
    helperStyle: tsL.bodyS.copyWith(
      color: colorsL.contentSupport,
    ),
    floatingLabelStyle: WidgetStateTextStyle.resolveWith(
      (states) {
        late final Color textColor;

        if (states.contains(WidgetState.error)) {
          textColor = colorsL.contentNegative;
        } else if (states.contains(WidgetState.focused)) {
          textColor = colorsL.borderFocused;
        } else if (states.contains(WidgetState.disabled)) {
          textColor = colorsL.contentDisabled;
        } else {
          textColor = colorsL.contentPrimary;
        }

        return tsL.bodyS.copyWith(
          backgroundColor: colorsL.borderSelected,
          color: textColor,
        );
      },
    ),
  );

  static InputDecorationTheme dark() => InputDecorationTheme(
    helperMaxLines: 1,
    errorMaxLines: 1,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: colorsD.borderSupport),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorsD.borderDisabled),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorsD.borderFocused),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorsD.contentNegative),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: colorsD.contentNegative),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorsD.borderDisabled),
    ),
    focusColor: colorsD.contentBrand,
    hoverColor: colorsD.borderHovered,
    fillColor: colorsD.backgroundPrimary,
    hintStyle: tsD.titleL.copyWith(
      color: colorsD.contentTertiary,
    ),
    errorStyle: tsD.bodyS.copyWith(
      color: colorsD.contentNegative,
    ),
    labelStyle: tsD.bodyS.copyWith(
      color: colorsD.contentPrimary,
    ),
    helperStyle: tsD.bodyS.copyWith(
      color: colorsD.contentSupport,
    ),
    floatingLabelStyle: WidgetStateTextStyle.resolveWith(
      (states) {
        late final Color textColor;

        if (states.contains(WidgetState.error)) {
          textColor = colorsD.contentNegative;
        } else if (states.contains(WidgetState.focused)) {
          textColor = colorsD.borderFocused;
        } else if (states.contains(WidgetState.disabled)) {
          textColor = colorsD.contentDisabled;
        } else {
          textColor = colorsD.contentPrimary;
        }

        return tsD.bodyS.copyWith(
          backgroundColor: colorsD.borderSupport,
          color: textColor,
        );
      },
    ),
  );
}
