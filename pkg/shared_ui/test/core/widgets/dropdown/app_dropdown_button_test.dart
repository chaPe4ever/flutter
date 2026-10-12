import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/dropdown/app_dropdown_button.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppDropdownButton validates and changes value', (tester) async {
    String? value = 'a';
    await pumpSharedUiWidget(
      tester,
      child: Form(
        child: AppDropdownButton(
          labelText: 'Label',
          items: const ['a', 'b'],
          value: value,
          errorText: 'err',
          validator: (v) => v == null ? 'required' : null,
          onChanged: (v) => value = v,
        ),
      ),
    );
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('b').last);
    await tester.pumpAndSettle();
    expect(value, 'b');
  });

  testWidgets('AppDropdownButton uses support label color with helper text', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: const Form(
        child: AppDropdownButton(
          labelText: 'Label',
          items: ['a'],
          value: 'a',
          helperText: 'Help',
        ),
      ),
    );
    expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    expect(find.byIcon(Icons.error), findsNothing);
  });

  testWidgets('AppDropdownButton uses primary label without helper text', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: const Form(
        child: AppDropdownButton(
          labelText: 'Label',
          items: ['a'],
          value: 'a',
        ),
      ),
    );
    expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
  });
}
