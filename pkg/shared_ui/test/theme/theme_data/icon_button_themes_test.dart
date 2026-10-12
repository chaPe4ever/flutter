import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/icon_button_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('IconButtonThemes', () {
    test('light and dark are IconButtonThemeData with overlay styles', () {
      expect(IconButtonThemes.light(), isA<IconButtonThemeData>());
      expect(IconButtonThemes.dark(), isA<IconButtonThemeData>());
      for (final theme in [IconButtonThemes.light(), IconButtonThemes.dark()]) {
        theme.style?.overlayColor?.resolve(emptyWidgetStates);
      }
    });
  });
}
