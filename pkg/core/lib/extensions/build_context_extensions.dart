import 'package:core/core.dart';
import 'package:core/widgets/layout/app_responsive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Build context extension
extension BuildContextX on BuildContext {
  /// Get theme brightness directly from context
  Brightness get themeBrightness => Theme.of(this).brightness;

  /// Get mediaQuery directly from context
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get size directly from context
  Size get size => MediaQuery.sizeOf(this);

  /// Get height directly from context
  double get height => size.height;

  /// Get width directly from context
  double get width => size.width;

  /// Get aspectRatio directly from context
  double get aspectRatio => size.aspectRatio;

  /// Get devicePixelRatio directly from context
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  /// Get textScaleFactor directly from context
  TextScaler get textScaleFactor => MediaQuery.textScalerOf(this);

  /// Get viewPadding directly from context
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  /// Get viewInsets directly from context
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Get the provider container from context, avoid using that though
  /// because of performance issues
  ProviderContainer get container => ProviderScope.containerOf(this);

  /// Get the shortest side of the screen
  double get shortestSize => size.shortestSide;

  /// Use the responsive to make your value responsive base on [BreakpointEnum]
  T responsive<T>(
    T fallBack, {
    T? xl,
    T? l,
    T? m,
    T? s,
    T? xs,
    T? web,
    T? desktop,
    T? tablet,
    T? mobile,
  }) {
    // Priority: Device type arguments override breakpoints
    if (web != null && BreakpointEnum.isWeb()) {
      return web;
    }
    if (desktop != null && BreakpointEnum.isDesktop()) {
      return desktop;
    }
    if (tablet != null && BreakpointEnum.isTablet(this)) {
      return tablet;
    }
    if (mobile != null && BreakpointEnum.isMobile(this)) {
      return mobile;
    }

    return width >= BreakpointEnum.xl.start
        ? (xl ?? l ?? m ?? s ?? xs ?? fallBack)
        : width >= BreakpointEnum.l.start
        ? (l ?? m ?? s ?? xs ?? fallBack)
        : width >= BreakpointEnum.m.start
        ? (m ?? s ?? xs ?? fallBack)
        : width >= BreakpointEnum.s.start
        ? (s ?? xs ?? fallBack)
        : width >= BreakpointEnum.xs.start
        ? (xs ?? fallBack)
        : fallBack;
  }

  /// Get the current focus scope node
  FocusScopeNode get currentFocus => FocusScope.of(this);

  /// Un-focus the current focus
  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) =>
      currentFocus.unfocus(disposition: disposition);

  // Theme specific
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get themeData directly from context
  ThemeData get themeData => Theme.of(this);

  AppImgTheme get appImgTheme => themeData.extension<AppImgTheme>()!;

  GoRouter get goRouter => GoRouter.of(this);

  NavigatorState navigator({bool rootNavigator = false}) =>
      Navigator.of(this, rootNavigator: rootNavigator);

  GoRouter? get goRouterMaybe => GoRouter.maybeOf(this);

  ResponsiveBreakpointsData get breakpointData =>
      AppResponsiveBreakpoints.of(this);

  double get breakPointStart => breakpointData.breakpoint.start;
  double get breakPointEnd => breakpointData.breakpoint.end;

  void navigatorPop<T extends Object?>([T? result]) =>
      Navigator.of(this).pop(result);
}
