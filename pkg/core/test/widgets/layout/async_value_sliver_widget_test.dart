import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncValueSliverWidget', () {
    testWidgets('shows data sliver when value has data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomScrollView(
            slivers: [
              AsyncValueSliverWidget<int>(
                value: const AsyncValue.data(7),
                data: (value) => SliverToBoxAdapter(
                  child: Text('sliver:$value'),
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.text('sliver:7'), findsOneWidget);
    });

    testWidgets('shows custom loading sliver', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomScrollView(
            slivers: [
              AsyncValueSliverWidget<int>(
                value: const AsyncValue.loading(),
                loadingWidget: const SliverToBoxAdapter(child: Text('loading')),
                data: (_) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
            ],
          ),
        ),
      );

      expect(find.text('loading'), findsOneWidget);
    });

    testWidgets('uses custom error callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomScrollView(
            slivers: [
              AsyncValueSliverWidget<int>(
                value: AsyncValue.error(Exception('fail'), StackTrace.empty),
                errorWidgetCb: (e, st) =>
                    SliverToBoxAdapter(child: Text('err:$e')),
                data: (_) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
            ],
          ),
        ),
      );

      expect(find.textContaining('err:Exception: fail'), findsOneWidget);
    });

    testWidgets('shows default debug error sliver for CoreException', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomScrollView(
            slivers: [
              AsyncValueSliverWidget<int>(
                value: AsyncValue.error(
                  const NoNetworkException(),
                  StackTrace.current,
                ),
                data: (_) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('ERROR_MESSAGE'), findsOneWidget);
    });
  });
}
