import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/input_decoration_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('InputDecorationThemes', () {
    test('light and dark resolve floating label styles', () {
      for (final theme in [
        InputDecorationThemes.light(),
        InputDecorationThemes.dark(),
      ]) {
        resolveWidgetStateTextStyle(
          theme.floatingLabelStyle,
          errorWidgetStates,
        );
        resolveWidgetStateTextStyle(
          theme.floatingLabelStyle,
          focusedWidgetStates,
        );
        resolveWidgetStateTextStyle(
          theme.floatingLabelStyle,
          disabledWidgetStates,
        );
        resolveWidgetStateTextStyle(
          theme.floatingLabelStyle,
          emptyWidgetStates,
        );
      }
    });
  });
}
