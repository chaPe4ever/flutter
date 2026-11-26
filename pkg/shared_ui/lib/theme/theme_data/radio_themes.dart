import 'package:material_ui/material_ui.dart';
import 'package:shared_ui/shared_ui.dart';

class RadioThemes {
  static RadioThemeData light() {
    return RadioThemeData(
      splashRadius: 0,
      fillColor: WidgetStateProperty.all(
        AppSemanticColors.light.backgroundBrand,
      ),
    );
  }

  static RadioThemeData dark() {
    return RadioThemeData(
      splashRadius: 0,
      fillColor: WidgetStateProperty.all(
        AppSemanticColors.dark.backgroundBrand,
      ),
    );
  }
}
