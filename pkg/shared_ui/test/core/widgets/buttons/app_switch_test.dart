import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/buttons/app_switch.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppSwitch toggles and shows label', (tester) async {
    bool? last;
    await pumpSharedUiWidget(
      tester,
      child: AppSwitch(
        value: true,
        label: 'Notify',
        onChanged: (v) => last = v,
      ),
    );
    expect(find.text('Notify'), findsOneWidget);
    await tester.tap(find.byType(AppSwitch));
    await tester.pump();
    expect(last, isTrue);
  });
}
