import 'package:core/enums/app_mode_enum.dart';
import 'package:flutter/foundation.dart';

base class AppModeStateBase {
  @protected
  late AppModeEnum initialMode;
  @protected
  late AppModeEnum _mode;
  AppModeEnum get currentMode => _mode;

  void setMode(AppModeEnum text) {
    _mode = text;
  }

  void reset() {
    _mode = initialMode;
  }
}

final class AppModeHelper extends AppModeStateBase {
  factory AppModeHelper() {
    return _instance;
  }

  AppModeHelper._internal() {
    initialMode = AppModeEnum.real;
    _mode = initialMode;
  }
  static final AppModeHelper _instance = AppModeHelper._internal();
}
