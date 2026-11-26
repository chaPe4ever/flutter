import 'package:material_ui/material_ui.dart';

extension LocaleX on Locale {
  /// Convert locale to String with custom separator
  String toStringWithSeparator({String separator = '_'}) {
    return toString().split('_').join(separator);
  }
}
