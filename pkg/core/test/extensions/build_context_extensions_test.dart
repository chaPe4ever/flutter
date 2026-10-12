import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  testWidgets('BuildContextX exposes theme and media metrics', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.dark,
            extensions: [AppImgTheme.light()],
          ),
          home: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(ctx.themeBrightness, Brightness.dark);
    expect(ctx.mediaQuery, isNotNull);
    expect(ctx.size, isNotNull);
    expect(ctx.height, greaterThan(0));
    expect(ctx.width, greaterThan(0));
    expect(ctx.aspectRatio, greaterThan(0));
    expect(ctx.devicePixelRatio, greaterThan(0));
    expect(ctx.textScaleFactor, isNotNull);
    expect(ctx.viewPadding, isNotNull);
    expect(ctx.viewInsets, isNotNull);
    expect(ctx.container, isNotNull);
    expect(ctx.shortestSize, greaterThan(0));
    expect(ctx.colorScheme, isNotNull);
    expect(ctx.themeData.brightness, Brightness.dark);
    expect(ctx.appImgTheme.color, Colors.black);
  });

  testWidgets(
    'BuildContextX responsive picks width breakpoint',
    (tester) async {
      late BuildContext ctx;
      await tester.binding.setSurfaceSize(const Size(500, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        ctx.responsive(
          'fb',
          xs: 'xs',
          s: 's',
          m: 'm',
          l: 'l',
          xl: 'xl',
        ),
        isNotEmpty,
      );
    },
  );

  testWidgets('BuildContextX goRouter and navigator', (tester) async {
    late BuildContext ctx;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox(key: Key('root'));
            },
          ),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(ctx.goRouter, isNotNull);
    expect(ctx.goRouterMaybe, isNotNull);
    expect(ctx.navigator(), isNotNull);
    expect(ctx.navigator(rootNavigator: true), isNotNull);
    expect(ctx.currentFocus, isNotNull);
    ctx
      ..unfocus()
      ..unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
  });

  testWidgets('BuildContextX responsive uses device-type overrides', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      ctx.responsive(
        'fb',
        mobile: 'mobile',
        tablet: 'tablet',
        desktop: 'desktop',
        web: 'web',
      ),
      'mobile',
    );

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('BuildContextX responsive uses width fallback below xs', (
    tester,
  ) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(300, 800)),
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      ctx.responsive('fallback', xs: 'xs'),
      'fallback',
    );
  });

  testWidgets('BuildContextX breakpoint data and navigatorPop', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: AppResponsiveBreakpoints.builder(
          breakpoints: const [Breakpoint(start: 0, end: 1200, name: MOBILE)],
          child: Builder(
            builder: (context) {
              ctx = context;
              return ElevatedButton(
                onPressed: () => context.navigatorPop<void>(),
                child: const Text('pop'),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(ctx.breakpointData, isNotNull);
    expect(ctx.breakPointStart, 0);
    expect(ctx.breakPointEnd, 1200);

    await tester.tap(find.text('pop'));
    await tester.pumpAndSettle();
  });
}
