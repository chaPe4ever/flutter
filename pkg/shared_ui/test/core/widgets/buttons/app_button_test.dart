import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/buttons/app_button.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets(
    'AppButton factories tap and expose theme colors',
    (tester) async {
      var primaryTapped = false;
      await pumpSharedUiWidget(
        tester,
        child: Column(
          children: [
            AppButton.primary(
              label: 'Primary',
              onTap: () => primaryTapped = true,
              leading: (c) => Icon(Icons.add, color: c),
              trailing: (c) => Icon(Icons.arrow_forward, color: c),
            ),
            AppButton.secondary(label: 'Secondary', onTap: () {}),
            AppButton.danger(label: 'Danger', onTap: () {}),
            AppButton.text(label: 'Text', onTap: () {}),
            AppButton.primary(label: 'Disabled'),
            Builder(
              builder: (context) {
                for (final type in AppButtonType.values) {
                  (switch (type) {
                      AppButtonType.primary => AppButton.primary(label: 'p'),
                      AppButtonType.secondary => AppButton.secondary(
                        label: 's',
                      ),
                      AppButtonType.danger => AppButton.danger(label: 'd'),
                      AppButtonType.text => AppButton.text(label: 't'),
                    })
                    ..padding(context)
                    ..childElementColor(context)
                    ..disabledChildElementColor(context)
                    ..hoverChildElementColor(context)
                    ..disabledColor(context)
                    ..backgroundColor(context)
                    ..focusColor(context)
                    ..hoverColor(context)
                    ..errorColor(context)
                    ..pressedColor(context)
                    ..selectedColor(context)
                    ..defaultBorder(context)
                    ..focusedBorder(context)
                    ..hoverBorder(context)
                    ..disabledBorder(context)
                    ..buttonStyle(context);
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      );

      await tester.tap(find.text('Primary'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(primaryTapped, isTrue);
      expect(find.text('Secondary'), findsOneWidget);
    },
  );
}
