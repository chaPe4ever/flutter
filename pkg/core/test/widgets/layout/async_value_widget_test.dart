import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncValueWidget', () {
    testWidgets('shows data builder when value has data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueWidget<int>(
            value: const AsyncValue.data(42),
            data: (value) => Text('value:$value'),
          ),
        ),
      );

      expect(find.text('value:42'), findsOneWidget);
    });

    testWidgets('shows custom loading widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueWidget<int>(
            value: const AsyncValue.loading(),
            loadingWidget: const Text('loading'),
            data: (_) => const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.text('loading'), findsOneWidget);
    });

    testWidgets(
      'shows default progress indicator when loading',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AsyncValueWidget<int>(
              value: const AsyncValue.loading(),
              data: (_) => const SizedBox.shrink(),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('uses custom error callback', (tester) async {
      final error = Exception('boom');
      final stack = StackTrace.current;

      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueWidget<int>(
            value: AsyncValue.error(error, stack),
            errorWidgetCb: (e, st) => Text('err:$e'),
            data: (_) => const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.textContaining('err:Exception: boom'), findsOneWidget);
    });

    testWidgets('shows default debug error UI for CoreException', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueWidget<int>(
            value: AsyncValue.error(
              const NoNetworkException(),
              StackTrace.current,
            ),
            data: (_) => const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.textContaining('ERROR_MESSAGE'), findsOneWidget);
    });

    testWidgets('shows default debug error UI for generic errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueWidget<int>(
            value: AsyncValue.error(Exception('boom'), StackTrace.current),
            data: (_) => const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.textContaining('ERROR_MESSAGE'), findsOneWidget);
    });
  });
}
