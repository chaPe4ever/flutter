import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/extensions/dartz_extensions.dart';

import '../../shared/pump_shared_ui_widget.dart';
import '../../shared/translations_setup.dart';

void main() {
  setUpAll(translationsSetup);

  group('EitherEx', () {
    testWidgets('whenDataElseSnackbar shows snackbar on left', (tester) async {
      final either = Left<CoreException, String>(UnknownCoreException());
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return either.whenDataElseSnackbar(
              Text.new,
              context: context,
            );
          },
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('whenDataElseSnackbar builds data widget on right', (
      tester,
    ) async {
      const either = Right<CoreException, String>('ok');
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return either.whenDataElseSnackbar(
              Text.new,
              context: context,
            );
          },
        ),
      );
      expect(find.text('ok'), findsOneWidget);
    });

    testWidgets('onDataElseSnackbarCb invokes callbacks', (tester) async {
      var dataCalled = false;
      var errorCalled = false;
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                await const Right<CoreException, int>(1).onDataElseSnackbarCb(
                  (v) async {
                    dataCalled = true;
                  },
                  context: context,
                );
              },
              child: const Text('right'),
            );
          },
        ),
      );
      await tester.tap(find.text('right'));
      await tester.pump();
      expect(dataCalled, isTrue);

      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                await Left<CoreException, int>(
                  UnknownCoreException(),
                ).onDataElseSnackbarCb(
                  (_) async {},
                  context: context,
                  onError: (_) async {
                    errorCalled = true;
                  },
                );
              },
              child: const Text('left'),
            );
          },
        ),
      );
      await tester.tap(find.text('left'));
      await tester.pump();
      await tester.pump();
      expect(errorCalled, isTrue);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
