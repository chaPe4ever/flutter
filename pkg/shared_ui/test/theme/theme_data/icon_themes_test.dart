import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/icon_themes.dart';

void main() {
  group('IconThemes', () {
    test('light and dark return IconThemeData', () {
      expect(IconThemes.light(), isA<IconThemeData>());
      expect(IconThemes.dark(), isA<IconThemeData>());
    });
  });
}
