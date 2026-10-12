import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/card_theme.dart';

void main() {
  group('CardThemes', () {
    test('light and dark return CardThemeData', () {
      expect(CardThemes.light(), isA<CardThemeData>());
      expect(CardThemes.dark(), isA<CardThemeData>());
    });
  });
}
