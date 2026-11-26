import 'package:material_ui/material_ui.dart';
import 'package:shared_ui/shared_ui.dart';

class IconThemes {
  static IconThemeData light() => IconThemeData(
    color: AppSemanticColors.light.contentPrimary,
  );

  static IconThemeData dark() => IconThemeData(
    color: AppSemanticColors.dark.contentPrimary,
  );
}
