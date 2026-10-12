import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/theme_data/radio_themes.dart';

import 'theme_data_test_helpers.dart';

void main() {
  group('RadioThemes', () {
    test('light and dark resolve fill colors', () {
      for (final theme in [RadioThemes.light(), RadioThemes.dark()]) {
        theme.fillColor?.resolve(selectedWidgetStates);
        theme.fillColor?.resolve(emptyWidgetStates);
      }
    });
  });
}
