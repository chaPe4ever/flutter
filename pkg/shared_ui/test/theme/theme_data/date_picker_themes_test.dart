import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/date_picker_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('DatePickerThemes', () {
    test('light and dark resolve day foreground colors', () {
      for (final theme in [DatePickerThemes.light(), DatePickerThemes.dark()]) {
        theme.dayForegroundColor?.resolve(selectedWidgetStates);
        theme.dayForegroundColor?.resolve(emptyWidgetStates);
      }
    });
  });
}
