import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_text_theme.dart';
import 'package:shared_ui/theme/theme_data/snack_bar_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('SnackBarThemes', () {
    test('light and dark resolve background and action colors', () {
      for (final theme in [SnackBarThemes.light(), SnackBarThemes.dark()]) {
        resolveWidgetStateColor(theme.backgroundColor, emptyWidgetStates);
        resolveWidgetStateColor(theme.actionTextColor, emptyWidgetStates);
      }
    });

    test('exposes platform text styles for light and dark', () {
      expect(SnackBarThemes.tsL, isA<PlatformTextStyles>());
      expect(SnackBarThemes.tsD, isA<PlatformTextStyles>());
    });
  });
}
