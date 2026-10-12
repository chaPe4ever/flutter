import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/bars/app_bottom_button_bar.dart';
import 'package:shared_ui/core/widgets/buttons/app_button.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppBottomButtonBar factory layouts', (tester) async {
    var primary = 0;
    var secondary = 0;
    await pumpSharedUiWidget(
      tester,
      child: Column(
        children: [
          AppBottomButtonBar.singlePrimary(
            label: 'Go',
            onTap: () => primary++,
          ),
          AppBottomButtonBar.singleSecondary(
            label: 'Back',
            onTap: () => secondary++,
          ),
          AppBottomButtonBar.doubleMix(
            labelPrimary: 'Save',
            labelSecondary: 'Cancel',
            onPrimaryTap: () => primary++,
            onSecondaryTap: () => secondary++,
          ),
          AppBottomButtonBar.doubleSecondary(
            labelFirst: 'First',
            labelSecond: 'Second',
            onFirstTap: () => secondary++,
            onSecondTap: () => primary++,
          ),
        ],
      ),
    );
    expect(find.byType(AppButton), findsWidgets);
    await tester.tap(find.text('Go'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(primary, 1);
  });
}
