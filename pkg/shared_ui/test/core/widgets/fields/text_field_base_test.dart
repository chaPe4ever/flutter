import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/fields/app_text_field.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets(
    'OutlineTextFieldBase validator shows error icon',
    (tester) async {
      final key = GlobalKey<FormState>();
      await pumpSharedUiWidget(
        tester,
        child: Form(
          key: key,
          child: AppTextField(
            labelText: 'Field',
            validator: (v) => 'bad',
            errorText: 'bad',
          ),
        ),
      );
      key.currentState!.validate();
      await tester.pump();
      expect(find.byIcon(Icons.error), findsOneWidget);
    },
  );

  testWidgets('text field styles disabled and focused states', (tester) async {
    await pumpSharedUiWidget(
      tester,
      child: AppTextField(
        labelText: 'Disabled',
        enabled: false,
      ),
    );
    await pumpSharedUiWidget(
      tester,
      child: AppTextField(
        labelText: 'Focused',
      ),
    );
    await tester.tap(find.byType(TextFormField));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), 'x');
    await tester.pump();
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
  });

  testWidgets('TextFieldBase style resolves widget states', (tester) async {
    final field = AppTextField(labelText: 'Styled');
    await pumpSharedUiWidget(
      tester,
      child: Builder(
        builder: (context) {
          final style = field.style(context) as WidgetStateTextStyle;
          for (final states in [
            {WidgetState.error},
            {WidgetState.focused},
            {WidgetState.disabled},
            <WidgetState>{},
          ]) {
            expect(style.resolve(states).color, isNotNull);
          }
          return field;
        },
      ),
    );
  });

  testWidgets('TextField onTapOutside callback runs', (tester) async {
    await pumpSharedUiWidget(
      tester,
      child: AppTextField(labelText: 'Name'),
    );
    final textField = tester.widget<TextField>(find.byType(TextField));
    textField.onTapOutside!(const PointerDownEvent());
    await tester.pump();
  });

  testWidgets('text field label uses helper and primary colors', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: AppTextField(
        labelText: 'With helper',
        helperText: 'Help',
      ),
    );
    expect(find.text('With helper'), findsOneWidget);

    await pumpSharedUiWidget(
      tester,
      child: AppTextField(labelText: 'Primary'),
    );
    expect(find.text('Primary'), findsOneWidget);
  });
}
