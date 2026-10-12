import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/layout/app_startup_loading_widget.dart';
import 'package:shared_ui/core/widgets/loading/app_loading_indicator.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppStartupLoadingWidget shows loading indicator', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      wrapWithScaffold: false,
      settle: false,
      child: const AppStartupLoadingWidget(),
    );
    await tester.pump();
    expect(find.byType(AppLoadingIndicator), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
