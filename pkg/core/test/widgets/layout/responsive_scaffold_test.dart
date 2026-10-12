import 'package:core/widgets/layout/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveScaffold', () {
    testWidgets('wraps body in scaffold with optional chrome', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveScaffold(
            horizontalPadding: 0,
            appBar: AppBar(title: const Text('title')),
            floatingActionButton: const FloatingActionButton(
              onPressed: _noop,
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: const Text('nav'),
            child: const Text('body'),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
      expect(find.text('title'), findsOneWidget);
      expect(find.text('nav'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}

void _noop() {}
