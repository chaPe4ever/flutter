import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/buttons/app_radio_button.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppRadioButton selects value on tap', (tester) async {
    String? selected;
    await pumpSharedUiWidget(
      tester,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AppRadioButton<String>(
            value: 'a',
            groupValue: selected,
            label: 'Option A',
            onChanged: (v) => setState(() => selected = v),
          );
        },
      ),
    );
    await tester.tap(find.text('Option A'));
    await tester.pump();
    expect(find.byType(Radio<String>), findsOneWidget);
  });
}
