import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/loading/app_loading_indicator.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppLoadingIndicator renders progress indicator', (tester) async {
    await pumpSharedUiWidget(
      tester,
      settle: false,
      child: const AppLoadingIndicator(),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
