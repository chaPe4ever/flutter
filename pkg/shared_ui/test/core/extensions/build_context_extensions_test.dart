import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../shared/pump_shared_ui_widget.dart';
import '../../shared/translations_setup.dart';

void main() {
  setUpAll(translationsSetup);

  group('BuildContextEx', () {
    testWidgets('textStyles and colors resolve from theme', (tester) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            expect(context.textStyles.bodyM, isNotNull);
            expect(context.colors.backgroundPrimary, isNotNull);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('showDialogPrimary opens primary dialog', (tester) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => context.showDialogPrimary<void>(
                title: 'Title',
                primaryText: 'Done',
                content: 'Body',
                onPrimaryTap: () {},
              ),
              child: const Text('open-primary'),
            );
          },
        ),
      );
      await tester.tap(find.text('open-primary'));
      await tester.pumpAndSettle();
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('showCustomDialog and showDialogPrimary', (tester) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                await context.showCustomDialog<void>(
                  child: const Text('custom'),
                );
              },
              child: const Text('open-custom'),
            );
          },
        ),
      );
      await tester.tap(find.text('open-custom'));
      await tester.pumpAndSettle();
      expect(find.text('custom'), findsOneWidget);
    });

    testWidgets('showDialogSecondary', (tester) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => context.showDialogSecondary<void>(
                title: 't',
                primaryText: 'ok',
                secondaryText: 'cancel',
              ),
              child: const Text('open-secondary'),
            );
          },
        ),
      );
      await tester.tap(find.text('open-secondary'));
      await tester.pumpAndSettle();
      expect(find.text('ok'), findsOneWidget);
    });

    testWidgets('showDialogDanger', (tester) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => context.showDialogDanger<void>(
                title: 't',
                dangerText: 'delete',
                secondaryText: 'cancel',
              ),
              child: const Text('open-danger'),
            );
          },
        ),
      );
      await tester.tap(find.text('open-danger'));
      await tester.pumpAndSettle();
      expect(find.text('delete'), findsOneWidget);
    });

    testWidgets('showSnackBar with and without action', (tester) async {
      var actionTapped = false;
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                TextButton(
                  onPressed: () => context.showSnackBar(text: 'hello'),
                  child: const Text('snack'),
                ),
                TextButton(
                  onPressed: () => context.showSnackBar(
                    text: 'act',
                    actionLabel: 'undo',
                    onActionTap: () => actionTapped = true,
                  ),
                  child: const Text('snack-action'),
                ),
                TextButton(
                  onPressed: context.hideSnackbar,
                  child: const Text('hide'),
                ),
              ],
            );
          },
        ),
      );
      await tester.tap(find.text('snack'));
      await tester.pump();
      expect(find.text('hello'), findsOneWidget);
      await tester.tap(find.text('hide'));
      await tester.pump();

      await tester.tap(find.text('snack-action'));
      await tester.pump();
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      snackBar.action!.onPressed();
      expect(actionTapped, isTrue);
    });

    testWidgets('showSnackBarError and showBottomSheet', (tester) async {
      var errorActionTapped = false;
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                TextButton(
                  onPressed: () => context.showSnackBarError(
                    UnknownCoreException(),
                  ),
                  child: const Text('snack-err'),
                ),
                TextButton(
                  onPressed: () => context.showSnackBarError(
                    UnknownCoreException(),
                    actionLabel: 'retry',
                    onActionTap: () => errorActionTapped = true,
                  ),
                  child: const Text('snack-err-action'),
                ),
                TextButton(
                  onPressed: () async {
                    await context.showBottomSheet<void>(
                      child: const Text('sheet-body'),
                    );
                  },
                  child: const Text('sheet'),
                ),
              ],
            );
          },
        ),
      );
      await tester.tap(find.text('snack-err'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);

      await tester.tap(find.text('snack-err-action'));
      await tester.pump();
      final errorSnackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      errorSnackBar.action!.onPressed();
      expect(errorActionTapped, isTrue);

      await tester.tap(find.text('sheet'));
      await tester.pumpAndSettle();
      expect(find.text('sheet-body'), findsOneWidget);
    });

    testWidgets('colors follow brightness', (tester) async {
      await pumpSharedUiWidget(
        tester,
        useDarkTheme: true,
        child: Builder(
          builder: (context) {
            expect(context.colors, AppSemanticColors.dark);
            return const SizedBox();
          },
        ),
      );
    });
  });
}
