import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/dividers/app_divider.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppDivider uses defaults and custom size/color', (tester) async {
    await pumpSharedUiWidget(
      tester,
      child: const Column(
        children: [
          AppDivider(key: Key('default')),
          AppDivider(width: 50, color: Colors.red, key: Key('custom')),
        ],
      ),
    );
    final defaultBox = tester.renderObject<RenderBox>(
      find.byKey(const Key('default')),
    );
    expect(defaultBox.size.width, 400);
    final customBox = tester.renderObject<RenderBox>(
      find.byKey(const Key('custom')),
    );
    expect(customBox.size.width, 50);
  });
}
