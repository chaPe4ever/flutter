import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shared/fakes.dart';

void main() {
  group('LoggerHelper', () {
    testWidgets('logAndThrow logs and rethrows the exception', (tester) async {
      final logger = FakeLogger();
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            overrides: [loggerPod.overrideWithValue(logger)],
            child: Consumer(
              builder: (context, ref, _) {
                return ElevatedButton(
                  onPressed: () {
                    LoggerHelper.logAndThrow<Never>(
                      e: const NoNetworkException(),
                      ref: ref,
                    );
                  },
                  child: const Text('throw'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('throw'));
      final thrown = await tester.takeException();
      expect(thrown, isA<NoNetworkException>());
      expect(logger.errorMessages, isNotEmpty);
    });

    testWidgets('logError uses logger when ref is provided', (tester) async {
      final logger = FakeLogger();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [loggerPod.overrideWithValue(logger)],
          child: Consumer(
            builder: (context, ref, _) {
              LoggerHelper.logError(
                e: const NoNetworkException(),
                ref: ref,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(logger.errorMessages, isNotEmpty);
    });

    test('logError logs to console when ref is null', () {
      expect(
        () => LoggerHelper.logError(e: const NoNetworkException()),
        returnsNormally,
      );
    });
  });
}
