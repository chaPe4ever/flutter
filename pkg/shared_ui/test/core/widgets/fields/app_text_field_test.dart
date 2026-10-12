import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/fields/app_text_field.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppTextField primary factory accepts input and clears', (
    tester,
  ) async {
    String? changed;
    await pumpSharedUiWidget(
      tester,
      child: AppTextField(
        labelText: 'Name',
        helperText: 'Hint',
        onChanged: (v) => changed = v,
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'Ada');
    await tester.pump();
    expect(changed, 'Ada');
    await tester.tap(find.byIcon(Icons.cancel_outlined));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('AppTextField specialized factories build', (tester) async {
    await pumpSharedUiWidget(
      tester,
      child: Column(
        children: [
          AppTextField.email(labelText: 'Email'),
          AppTextField.password(labelText: 'Password'),
          AppTextField.firstName(labelText: 'First'),
          AppTextField.lastName(labelText: 'Last'),
        ],
      ),
    );
    expect(find.byType(TextFormField), findsNWidgets(4));
    await tester.tap(find.byIcon(Icons.visibility).first);
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('AppTextField specialized validators run', (tester) async {
    final key = GlobalKey<FormState>();
    await pumpSharedUiWidget(
      tester,
      child: Form(
        key: key,
        child: Column(
          children: [
            AppTextField.email(
              labelText: 'Email',
              validator: (_) => 'email err',
            ),
            AppTextField.password(
              labelText: 'Password',
              validator: (_) => 'pw err',
            ),
            AppTextField.firstName(
              labelText: 'First',
              validator: (_) => 'first err',
            ),
            AppTextField.lastName(
              labelText: 'Last',
              validator: (_) => 'last err',
            ),
          ],
        ),
      ),
    );
    key.currentState!.validate();
    await tester.pump();
    expect(find.text('email err'), findsOneWidget);
  });
}
