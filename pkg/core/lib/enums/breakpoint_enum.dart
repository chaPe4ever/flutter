import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// This enum is used to define the breakpoints for the responsive design.
/// The [end] property represents the max width of the breakpoint.
enum BreakpointEnum {
  xl(1440, 1920),
  l(1024, 1439),
  m(768, 1023),
  s(393, 767),
  xs(320, 392);

  const BreakpointEnum(this.start, this.end);

  final double end;
  final double start;

  /// Helper methods to determine device type based on width
  static bool isMobile(BuildContext context) =>
      !kIsWeb &&
      switch (defaultTargetPlatform) {
        TargetPlatform.android || TargetPlatform.iOS => true,
        _ => false,
      } &&
      context.width >= xs.start &&
      context.width <= s.end;

  static bool isTablet(BuildContext context) =>
      !kIsWeb &&
      switch (defaultTargetPlatform) {
        TargetPlatform.android || TargetPlatform.iOS => true,
        _ => false,
      } &&
      context.shortestSize >= 600 &&
      context.width >= m.start &&
      context.width <= m.end;

  static bool isDesktop() =>
      !kIsWeb &&
      switch (defaultTargetPlatform) {
        TargetPlatform.linux ||
        TargetPlatform.macOS ||
        TargetPlatform.windows =>
          true,
        _ => false,
      };

  static bool isWeb() => kIsWeb;
}
