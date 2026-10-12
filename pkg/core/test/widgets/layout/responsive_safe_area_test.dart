import 'package:core/widgets/layout/responsive_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveSafeArea', () {
    testWidgets('applies horizontal padding around child', (tester) async {
      const padding = 24.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveSafeArea(
            hPadding: padding,
            child: Text('content'),
          ),
        ),
      );

      expect(find.text('content'), findsOneWidget);

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ResponsiveSafeArea),
          matching: find.byType(Container),
        ),
      );
      expect(
        container.padding,
        const EdgeInsets.symmetric(horizontal: padding),
      );
    });
  });
}
