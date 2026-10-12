import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/floating_action_button_themes.dart';

void main() {
  group('FloatingActionButtonThemes', () {
    test('light and dark return FloatingActionButtonThemeData', () {
      expect(
        FloatingActionButtonThemes.light(),
        isA<FloatingActionButtonThemeData>(),
      );
      expect(
        FloatingActionButtonThemes.dark(),
        isA<FloatingActionButtonThemeData>(),
      );
    });
  });
}
