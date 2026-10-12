import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/dialog_themes.dart';

void main() {
  group('DialogThemes', () {
    test('light and dark return DialogThemeData', () {
      expect(DialogThemes.light(), isA<DialogThemeData>());
      expect(DialogThemes.dark(), isA<DialogThemeData>());
    });
  });
}
