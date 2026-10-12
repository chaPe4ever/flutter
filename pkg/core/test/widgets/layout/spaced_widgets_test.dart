import 'package:core/widgets/layout/spaced_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/gap.dart';

void main() {
  group('SpacedColumn', () {
    testWidgets('inserts gaps between non-null children', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SpacedColumn(
            spacing: 8,
            children: [
              Text('a'),
              null,
              Text('b'),
            ],
          ),
        ),
      );

      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
      expect(find.byType(Gap), findsNWidgets(1));

      final gap = tester.widget<Gap>(find.byType(Gap));
      expect(gap.mainAxisExtent, 8);
    });

    testWidgets('gapAtStart and gapAtEnd add leading and trailing gaps', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SpacedColumn(
            gapAtStart: true,
            gapAtEnd: true,
            children: [Text('only')],
          ),
        ),
      );

      expect(find.byType(Gap), findsNWidgets(2));
    });
  });

  group('SpacedRow', () {
    testWidgets('inserts gaps between non-null children', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SpacedRow(
            spacing: 12,
            children: [Text('x'), Text('y')],
          ),
        ),
      );

      expect(find.byType(Gap), findsOneWidget);
      expect(tester.widget<Gap>(find.byType(Gap)).mainAxisExtent, 12);
    });
  });
}
