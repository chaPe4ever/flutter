import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/buttons/app_icon_button.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets(
    'AppIconButton variants render and expose colors',
    (tester) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            final buttons = <AppIconButton>[
              AppIconButton.primary(icon: Icons.star, onTap: () {}),
              AppIconButton.secondary(icon: Icons.star, onTap: () {}),
              AppIconButton.ouline(icon: Icons.star, onTap: () {}),
              AppIconButton.negative(icon: Icons.star, onTap: () {}),
              AppIconButton.back(onTap: () {}),
              AppIconButton.primary(icon: Icons.star),
            ];
            for (final button in buttons) {
              button
                ..padding(context)
                ..size(context)
                ..backgroundColor(context)
                ..disabledColor(context)
                ..focusColor(context)
                ..hoverColor(context)
                ..errorColor(context)
                ..pressedColor(context)
                ..selectedColor(context)
                ..childElementColor(context)
                ..hoverChildElementColor(context);
            }
            return Wrap(children: buttons);
          },
        ),
      );
      expect(find.byType(IconButton), findsWidgets);
    },
  );
}
