import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/dropdown/app_dropdown_button.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('DropdownButtonBase decoration respects helper text', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: Builder(
        builder: (context) {
          const button = AppDropdownButton(
            labelText: 'Pick',
            items: ['a'],
            helperText: 'Help',
          );
          final decoration = button.decoration(context);
          expect(decoration?.helperText, 'Help');
          expect(decoration?.labelText, 'Pick');
          return button;
        },
      ),
    );
    expect(find.byType(AppDropdownButton), findsOneWidget);
  });
}
