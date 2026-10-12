import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/dialogs/app_dialog.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppDialog primary secondary and danger actions', (tester) async {
    var primary = false;
    var secondary = false;
    var danger = false;

    await pumpSharedUiWidget(
      tester,
      child: Column(
        children: [
          AppDialog.primary(
            title: 'Primary',
            content: 'Body',
            primaryText: 'OK',
            onPrimaryTap: () => primary = true,
          ),
          AppDialog.secondary(
            title: 'Secondary',
            primaryText: 'OK',
            secondaryText: 'Cancel',
            onPrimaryTap: () => primary = true,
            onSecondaryTap: () => secondary = true,
          ),
          AppDialog.danger(
            title: 'Danger',
            dangerText: 'Delete',
            secondaryText: 'Cancel',
            onDangerTap: () => danger = true,
            onSecondaryTap: () => secondary = true,
          ),
        ],
      ),
    );

    await tester.tap(find.text('OK').first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(primary, isTrue);

    await tester.tap(find.text('Cancel').first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(secondary, isTrue);

    await tester.tap(find.text('Delete'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(danger, isTrue);
  });
}
