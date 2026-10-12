import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/buttons/app_checkbox.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets(
    'AppCheckbox toggles via row tap and shows label',
    (tester) async {
      bool? last;
      await pumpSharedUiWidget(
        tester,
        child: AppCheckbox(
          value: false,
          label: 'Accept',
          onChanged: (v) => last = v,
        ),
      );
      expect(find.text('Accept'), findsOneWidget);
      await tester.tap(find.byType(AppCheckbox));
      await tester.pump();
      expect(last, isFalse);
    },
  );
}
