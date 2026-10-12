import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

class WebConfig implements ConfigBase {
  @override
  Future<void> init() async {
    usePathUrlStrategy();
    GoRouter.optionURLReflectsImperativeAPIs = true;
    configureWebFlutterErrorHandling();
  }
}

/// Installs web-only Flutter error logging (overridable in tests).
void configureWebFlutterErrorHandling({
  bool isWeb = kIsWeb,
  bool releaseMode = kReleaseMode,
  void Function(String message, {StackTrace? st})? logError,
}) {
  if (!isWeb) {
    return;
  }
  final logger = logError ?? Log.error;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (!releaseMode) {
      logger(details.exceptionAsString(), st: details.stack);
    }
  };
}
