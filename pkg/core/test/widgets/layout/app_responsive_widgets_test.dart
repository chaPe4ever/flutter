import 'package:core/enums/breakpoint_enum.dart';
import 'package:core/widgets/layout/app_responsive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  group('ResponsiveTwoColumnLayout', () {
    testWidgets('uses row layout when width meets breakpoint end', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(
        Size(BreakpointEnum.m.end + 50, 800),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: BreakpointEnum.m.end + 50,
            child: const ResponsiveTwoColumnLayout(
              spacing: 16,
              startContent: Text('start'),
              endContent: Text('end'),
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.text('start'), findsOneWidget);
      expect(find.text('end'), findsOneWidget);
    });

    testWidgets('uses column layout when width is below breakpoint end', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: BreakpointEnum.m.end - 50,
              child: const ResponsiveTwoColumnLayout(
                spacing: 8,
                startContent: Text('start'),
                endContent: Text('end'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
    });
  });

  group('ResponsiveCenter', () {
    testWidgets('centers child with max width from breakpoint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveCenter(
            breakpoint: BreakpointEnum.s,
            child: Text('centered'),
          ),
        ),
      );

      expect(find.text('centered'), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(ResponsiveCenter),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, BreakpointEnum.s.end);
    });
  });

  group('ResponsiveSliverCenter', () {
    testWidgets('wraps ResponsiveCenter in a sliver', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CustomScrollView(
            slivers: [
              ResponsiveSliverCenter(child: Text('in sliver')),
            ],
          ),
        ),
      );

      expect(find.byType(SliverToBoxAdapter), findsOneWidget);
      expect(find.text('in sliver'), findsOneWidget);
    });
  });

  group('AppRowColumnTypeX', () {
    test('maps to responsive_framework enum values', () {
      expect(
        AppRowColumnType.row.toResponsiveRowColumnType,
        ResponsiveRowColumnType.ROW,
      );
      expect(
        AppRowColumnType.column.toResponsiveRowColumnType,
        ResponsiveRowColumnType.COLUMN,
      );
    });
  });

  group('AppConditionalX', () {
    test('maps to responsive_framework conditional values', () {
      expect(
        AppConditional.largerThan.toConditional,
        Conditional.LARGER_THAN,
      );
      expect(AppConditional.equals.toConditional, Conditional.EQUALS);
      expect(
        AppConditional.smallerThan.toConditional,
        Conditional.SMALLER_THAN,
      );
      expect(AppConditional.between.toConditional, Conditional.BETWEEN);
    });
  });

  group('AppResponsiveRowColumn', () {
    testWidgets('delegates to ResponsiveRowColumn', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppResponsiveRowColumn(
            layout: AppRowColumnType.row,
            rowSpacing: 4,
            children: [
              AppResponsiveRowColumnItem(child: Text('a')),
              AppResponsiveRowColumnItem(child: Text('b')),
            ],
          ),
        ),
      );

      expect(find.byType(ResponsiveRowColumn), findsOneWidget);
      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
    });
  });

  group('AppResponsiveBreakpoints', () {
    testWidgets('builder provides breakpoint data to descendants', (
      tester,
    ) async {
      ResponsiveBreakpointsData? captured;

      await tester.pumpWidget(
        MaterialApp(
          home: AppResponsiveBreakpoints.builder(
            breakpoints: const [
              Breakpoint(start: 0, end: 450, name: MOBILE),
              Breakpoint(start: 451, end: 800, name: TABLET),
            ],
            child: Builder(
              builder: (context) {
                captured = AppResponsiveBreakpoints.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(captured, isNotNull);
    });

    testWidgets('of throws when no ResponsiveBreakpoints ancestor', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: SizedBox.shrink()),
      );

      expect(
        () => AppResponsiveBreakpoints.of(
          tester.element(find.byType(SizedBox)),
        ),
        throwsFlutterError,
      );
    });
  });

  group('AppResponsiveScaledBox', () {
    testWidgets('wraps child in ResponsiveScaledBox', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppResponsiveScaledBox(
            width: 1200,
            child: Text('scaled'),
          ),
        ),
      );

      expect(find.byType(ResponsiveScaledBox), findsOneWidget);
      expect(find.text('scaled'), findsOneWidget);
    });
  });

  group('ResponsiveScrollableCard', () {
    testWidgets('renders scrollable card around child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveScrollableCard(child: Text('form')),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('form'), findsOneWidget);
    });
  });

  group('AppMaxWidthBox', () {
    testWidgets('wraps child in MaxWidthBox', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppMaxWidthBox(
            maxWidth: 400,
            child: Text('bounded'),
          ),
        ),
      );

      expect(find.byType(MaxWidthBox), findsOneWidget);
      expect(find.text('bounded'), findsOneWidget);
    });
  });

  group('AppResponsiveGrid', () {
    testWidgets('builds responsive grid items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            height: 200,
            child: AppResponsiveGrid(
              gridDelegate: const ResponsiveGridDelegate(
                minCrossAxisExtent: 80,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: 2,
              itemBuilder: (context, index) => Text('item$index'),
            ),
          ),
        ),
      );

      expect(find.text('item0'), findsOneWidget);
      expect(find.text('item1'), findsOneWidget);
    });
  });

  group('AppResponsiveVisibility', () {
    testWidgets('shows child when visible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppResponsiveBreakpoints.builder(
            breakpoints: const [Breakpoint(start: 0, end: 800, name: MOBILE)],
            child: const AppResponsiveVisibility(child: Text('shown')),
          ),
        ),
      );

      expect(find.text('shown'), findsOneWidget);
    });
  });

  group('AppBreakpoint and AppCondition', () {
    testWidgets('AppResponsiveValue and conditions render', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppResponsiveBreakpoints.builder(
            breakpoints: const [Breakpoint(start: 0, end: 1200, name: MOBILE)],
            child: Builder(
              builder: (context) {
                final responsiveValue = AppResponsiveValue<String>(
                  context,
                  conditionalValues: [
                    const AppCondition.largerThan(
                      breakpoint: 0,
                      value: 'large',
                    ),
                    AppCondition.equals(name: MOBILE, value: 'mobile'),
                    const AppCondition.smallerThan(
                      breakpoint: 2000,
                      value: 'small',
                    ),
                    const AppCondition.between(
                      start: 0,
                      end: 1200,
                      value: 'between',
                    ),
                  ],
                  defaultValue: 'default',
                );
                return Text(responsiveValue.value);
              },
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    test('AppBreakpoint stores breakpoint bounds', () {
      const breakpoint = AppBreakpoint(start: 0, end: 500, name: 'test');
      expect(breakpoint.start, 0);
      expect(breakpoint.end, 500);
    });

    testWidgets('AppResponsiveBreakpoints widget constructor', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppResponsiveBreakpoints(
            breakpoints: [Breakpoint(start: 0, end: 800, name: MOBILE)],
            child: Text('child'),
          ),
        ),
      );

      expect(find.text('child'), findsOneWidget);
    });
  });

  group('AppResponsiveConstraints', () {
    testWidgets('wraps child in ResponsiveConstraints', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppResponsiveBreakpoints.builder(
            breakpoints: const [Breakpoint(start: 0, end: 800, name: MOBILE)],
            child: const AppResponsiveConstraints(
              constraint: BoxConstraints(maxWidth: 300),
              child: Text('constrained'),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveConstraints), findsOneWidget);
      expect(find.text('constrained'), findsOneWidget);
    });
  });
}
