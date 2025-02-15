import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WmConfig implements Config {
  @override
  Future<void> init({
    double? minScreenWidth,
    double? defaultScreenWidth,
    double? minScreenHeight,
    double? defaultScreenHeight,
    double? maxScreenWidth,
    double? maxScreenHeight,
  }) async {
    await switch (defaultTargetPlatform) {
      TargetPlatform.windows ||
      TargetPlatform.macOS ||
      TargetPlatform.linux => windowManager.ensureInitialized(),
      _ => Future<void>.value(),
    };

    await switch (defaultTargetPlatform) {
      TargetPlatform.windows ||
      TargetPlatform.macOS ||
      TargetPlatform.linux => () async {
        final minWidth = minScreenWidth ?? BreakpointEnum.xs.start;
        final minHeight = minScreenHeight ?? ScreenSizes.minHeight;
        final defaultWidth = defaultScreenWidth ?? BreakpointEnum.l.start;
        final defaultHeight = defaultScreenHeight ?? BreakpointEnum.m.start;
        final maxWidth = maxScreenWidth ?? BreakpointEnum.xl.end;
        final maxHeight = maxScreenHeight ?? ScreenSizes.maxHeight;

        // Waiting this method blocks the hot reload and then the app doesn't
        // work properly. So, it's better to use it only in production.
        final wmFn = windowManager.waitUntilReadyToShow(
          WindowOptions(
            size: Size(
              kDebugMode ? minWidth : defaultWidth,
              kDebugMode ? minHeight : defaultHeight,
            ),
            minimumSize: Size(minWidth, minHeight),
            maximumSize: Size(maxWidth, maxHeight),
            center: !kDebugMode,
            backgroundColor: Colors.transparent,
            skipTaskbar: false,
            titleBarStyle: TitleBarStyle.normal,
          ),
          () async => windowManager.show(),
        );
        return kDebugMode ? unawaited(wmFn) : await wmFn;
      },
      _ => () async {},
    }();
  }
}
