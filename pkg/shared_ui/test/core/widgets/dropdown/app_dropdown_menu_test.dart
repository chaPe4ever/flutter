import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/dropdown/app_dropdown_menu.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppDropdownMenu validates selection', (tester) async {
    String? selected = 'one';
    await pumpSharedUiWidget(
      tester,
      child: Form(
        child: AppDropdownMenu(
          labelText: 'Choose',
          items: const ['one', 'two'],
          value: selected,
          helperText: 'Help',
          validator: (v) => v == null ? 'required' : null,
          onChanged: (v) => selected = v,
        ),
      ),
    );
    expect(find.byType(DropdownMenu<String>), findsOneWidget);
    await tester.tap(find.byType(DropdownMenu<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('two').last);
    await tester.pumpAndSettle();
    expect(selected, 'two');
  });

  testWidgets('AppDropdownMenu shows error styling when invalid', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        child: AppDropdownMenu(
          labelText: 'Choose',
          items: const ['one', 'two'],
          errorText: 'Bad',
          validator: (_) => 'Bad',
        ),
      ),
    );
    await tester.pump();
    expect(find.byIcon(Icons.error), findsWidgets);
  });

  testWidgets('AppDropdownMenu uses support label color with helper text', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: const Form(
        child: AppDropdownMenu(
          labelText: 'Choose',
          items: ['one', 'two'],
          value: 'one',
          helperText: 'Help',
        ),
      ),
    );
    expect(find.byType(DropdownMenu<String>), findsOneWidget);
    expect(find.text('Help'), findsOneWidget);
  });

  testWidgets('AppDropdownMenu uses primary label without helper text', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: const Form(
        child: AppDropdownMenu(
          labelText: 'Choose',
          items: ['one', 'two'],
          value: 'one',
        ),
      ),
    );
    expect(find.byIcon(Icons.arrow_drop_down), findsWidgets);
  });

  testWidgets('AppDropdownMenu entry styles include selected state', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: Form(
        child: AppDropdownMenu(
          labelText: 'Choose',
          items: const ['one', 'two'],
          value: 'one',
          onChanged: (_) {},
        ),
      ),
    );
    await tester.tap(find.byType(DropdownMenu<String>));
    await tester.pumpAndSettle();

    final menu = tester.widget<DropdownMenu<String>>(
      find.byType(DropdownMenu<String>),
    );
    final background = menu.dropdownMenuEntries.first.style!.backgroundColor!;
    expect(
      background.resolve({WidgetState.selected}),
      isNotNull,
    );
    expect(
      background.resolve(<WidgetState>{}),
      isNotNull,
    );

    await tester.tap(find.text('two').last);
    await tester.pumpAndSettle();
    expect(find.byType(DropdownMenu<String>), findsOneWidget);
  });
}
