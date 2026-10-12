import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/bottom_sheet_themes.dart';

void main() {
  group('BottomSheetThemes', () {
    test('light and dark return BottomSheetThemeData', () {
      expect(BottomSheetThemes.light(), isA<BottomSheetThemeData>());
      expect(BottomSheetThemes.dark(), isA<BottomSheetThemeData>());
    });
  });
}
