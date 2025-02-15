import 'package:core/core.dart';

extension BoolSignalX on Signal<bool> {
  void toggle() {
    value = !value;
  }
}
