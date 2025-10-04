// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

class WebConfig implements ConfigBase {
  @override
  Future<void> init() async {
    usePathUrlStrategy();
    GoRouter.optionURLReflectsImperativeAPIs = true;
    if (kIsWeb) {
      FlutterError.onError = (FlutterErrorDetails details) {
        // Print the error details to the console
        if (!kReleaseMode) {
          Log.error(details.exceptionAsString(), st: details.stack);
        }
      };
    }
  }
}
