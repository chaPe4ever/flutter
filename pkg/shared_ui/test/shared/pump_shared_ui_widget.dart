import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/app_theme.dart';
import 'package:shared_ui/theme/pallete/app_semantic_colors.dart';

import 'go_router_mocks.dart';
import 'provider_container.dart';

Future<ProviderContainer> pumpSharedUiWidget(
  WidgetTester tester, {
  required Widget child,
  List<Override>? overrides,
  GoRouter? mockGoRouter,
  Size? physicalSize,
  double devicePixelRatio = 1,
  bool wrapWithScaffold = true,
  bool settle = true,
  bool useDarkTheme = false,
  GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  physicalSize ??= const Size(400, 800);
  tester.view.physicalSize = physicalSize;
  tester.view.devicePixelRatio = devicePixelRatio;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final container = makeProviderContainer(overrides: overrides);
  final appTheme = AppTheme();
  final router = mockGoRouter ?? stubbedGoRouter();
  final home = InheritedGoRouter(
    goRouter: router,
    child: wrapWithScaffold
        ? Scaffold(
            backgroundColor: useDarkTheme
                ? AppSemanticColors.dark.backgroundPrimary
                : AppSemanticColors.light.backgroundPrimary,
            body: child,
          )
        : child,
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: scaffoldMessengerKey,
            theme: useDarkTheme
                ? appTheme.dark(context)
                : appTheme.light(context),
            home: home,
          );
        },
      ),
    ),
  );

  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  return container;
}
