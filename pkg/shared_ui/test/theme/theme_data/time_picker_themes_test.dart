import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/time_picker_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('TimePickerThemes', () {
    test('light and dark resolve dial text colors', () {
      for (final theme in [TimePickerThemes.light(), TimePickerThemes.dark()]) {
        resolveWidgetStateColor(
          theme.dialTextColor,
          selectedWidgetStates,
        );
        resolveWidgetStateColor(theme.dialTextColor, emptyWidgetStates);
      }
    });
  });
}
