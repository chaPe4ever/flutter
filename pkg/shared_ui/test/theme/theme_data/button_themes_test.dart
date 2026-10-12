import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/button_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('ButtonThemes', () {
    test('text buttons resolve background for hover and default', () {
      for (final style in [
        ButtonThemes.textLight().style,
        ButtonThemes.textDark().style,
      ]) {
        style?.backgroundColor?.resolve(hoveredWidgetStates);
        style?.backgroundColor?.resolve(emptyWidgetStates);
      }
    });

    test('elevated and filled buttons resolve elevation', () {
      for (final style in [
        ButtonThemes.elevatedLight().style,
        ButtonThemes.elevatedDark().style,
        ButtonThemes.filledLight().style,
        ButtonThemes.filledDark().style,
      ]) {
        style?.elevation?.resolve(pressedWidgetStates);
        style?.elevation?.resolve(emptyWidgetStates);
      }
    });

    test('outlined themes are defined for light and dark', () {
      expect(ButtonThemes.outlinedLight(), isA<OutlinedButtonThemeData>());
      expect(ButtonThemes.outlinedDark(), isA<OutlinedButtonThemeData>());
    });

    test('icon button themes resolve overlay color', () {
      for (final style in [
        ButtonThemes.iconLight().style,
        ButtonThemes.iconDark().style,
      ]) {
        style?.overlayColor?.resolve(emptyWidgetStates);
      }
    });
  });
}
