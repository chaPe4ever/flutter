import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _sizedPlatformChild({
  required Size size,
  required bool Function(BuildContext context) assertion,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Builder(
      builder: (context) {
        expect(assertion(context), isTrue);
        return const SizedBox.shrink();
      },
    ),
  );
}

void main() {
  group('BreakpointEnum values', () {
    test('defines start and end for each breakpoint', () {
      expect(BreakpointEnum.xs.start, 320);
      expect(BreakpointEnum.xs.end, 392);
      expect(BreakpointEnum.s.start, 393);
      expect(BreakpointEnum.s.end, 767);
      expect(BreakpointEnum.m.start, 768);
      expect(BreakpointEnum.m.end, 1023);
      expect(BreakpointEnum.l.start, 1024);
      expect(BreakpointEnum.l.end, 1439);
      expect(BreakpointEnum.xl.start, 1440);
      expect(BreakpointEnum.xl.end, 1920);
    });
  });

  group('BreakpointEnum platform helpers', () {
    testWidgets('isMobile is true for phone-sized Android layouts', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpWidget(
        MaterialApp(
          home: _sizedPlatformChild(
            size: const Size(400, 800),
            assertion: BreakpointEnum.isMobile,
          ),
        ),
      );

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('isTablet is true for wide Android layouts', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpWidget(
        MaterialApp(
          home: _sizedPlatformChild(
            size: const Size(800, 1200),
            assertion: BreakpointEnum.isTablet,
          ),
        ),
      );

      debugDefaultTargetPlatformOverride = null;
    });

    test('isDesktop is true on desktop targets when not web', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(BreakpointEnum.isDesktop(), isTrue);
      debugDefaultTargetPlatformOverride = null;

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(BreakpointEnum.isDesktop(), isFalse);
      debugDefaultTargetPlatformOverride = null;
    });

    test('isWeb reflects kIsWeb', () {
      expect(BreakpointEnum.isWeb(), kIsWeb);
    });
  });
}
