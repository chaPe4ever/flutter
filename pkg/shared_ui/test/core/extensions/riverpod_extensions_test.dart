import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/extensions/riverpod_extensions.dart';

import '../../shared/pump_shared_ui_widget.dart';
import '../../shared/translations_setup.dart';

Future<void> _initFlavor(String flavor) async {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('flavor'),
        (call) async => flavor,
      );
  final result = await FlavorHelper.init();
  expect(result.isRight(), isTrue);
}

final asyncErrorPod = NotifierProvider<_AsyncErrorNotifier, AsyncValue<int>>(
  _AsyncErrorNotifier.new,
);

class _AsyncErrorNotifier extends Notifier<AsyncValue<int>> {
  @override
  AsyncValue<int> build() => const AsyncValue.data(0);
}

void main() {
  setUpAll(translationsSetup);

  group('WidgetRefEX', () {
    testWidgets('listenAndShowSnackBarOnError shows snackbar on failure', (
      tester,
    ) async {
      await _initFlavor('dev');
      late ProviderContainer container;
      container = await pumpSharedUiWidget(
        tester,
        child: Consumer(
          builder: (context, ref, _) {
            ref.listenAndShowSnackBarOnError(asyncErrorPod);
            return const SizedBox();
          },
        ),
      );
      container.read(asyncErrorPod.notifier).state = AsyncValue.error(
        Exception('fail'),
        StackTrace.empty,
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('listenAndShowSnackBarOnError stg appends inner error', (
      tester,
    ) async {
      await _initFlavor('stg');
      late ProviderContainer container;
      container = await pumpSharedUiWidget(
        tester,
        child: Consumer(
          builder: (context, ref, _) {
            ref.listenAndShowSnackBarOnError(
              asyncErrorPod,
              onError: () {},
            );
            return const SizedBox();
          },
        ),
      );
      container.read(asyncErrorPod.notifier).state = AsyncValue.error(
        UnknownCoreException(innerError: 'detail'),
        StackTrace.empty,
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('detail'), findsOneWidget);
    });
  });

  group('AsyncValueUiX', () {
    testWidgets('showAlertDialogOnError with CoreException', (tester) async {
      final value = AsyncValue<int>.error(
        UnknownCoreException(),
        StackTrace.empty,
      );
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                await value.showAlertDialogOnError(context);
              },
              child: const Text('alert'),
            );
          },
        ),
      );
      await tester.tap(find.text('alert'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('An unknown error has occurred'),
        findsOneWidget,
      );
    });

    testWidgets('showAlertDialogOnError with generic error and custom title', (
      tester,
    ) async {
      const value = AsyncValue<int>.error('nope', StackTrace.empty);
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                await value.showAlertDialogOnError(
                  context,
                  customTitle: 'Custom',
                );
              },
              child: const Text('alert2'),
            );
          },
        ),
      );
      await tester.tap(find.text('alert2'));
      await tester.pumpAndSettle();
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('showSnackBarOnError with generic error message', (
      tester,
    ) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                const AsyncValue<int>.error(
                  'plain',
                  StackTrace.empty,
                ).showSnackBarOnError(context);
              },
              child: const Text('snack-generic'),
            );
          },
        ),
      );
      await tester.tap(find.text('snack-generic'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('showSnackBarOnError and skips loading', (tester) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                const AsyncValue<int>.loading().showSnackBarOnError(context);
                AsyncValue<int>.error(
                  UnknownCoreException(),
                  StackTrace.empty,
                ).showSnackBarOnError(context);
              },
              child: const Text('snack'),
            );
          },
        ),
      );
      await tester.tap(find.text('snack'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
