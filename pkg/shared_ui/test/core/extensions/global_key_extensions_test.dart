import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/extensions/global_key_extensions.dart';

import '../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('GlobalKeyX.showSnackBar shows snackbar with action', (
    tester,
  ) async {
    final messengerKey = GlobalKey<ScaffoldMessengerState>();
    var actionTapped = false;

    await pumpSharedUiWidget(
      tester,
      wrapWithScaffold: false,
      scaffoldMessengerKey: messengerKey,
      child: Scaffold(
        body: TextButton(
          onPressed: () {
            messengerKey.showSnackBar(
              text: 'via-key',
              actionLabel: 'go',
              onActionTap: () => actionTapped = true,
            );
          },
          child: const Text('show'),
        ),
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pump();
    expect(find.text('via-key'), findsOneWidget);
    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    snackBar.action!.onPressed();
    expect(actionTapped, isTrue);
  });
}
