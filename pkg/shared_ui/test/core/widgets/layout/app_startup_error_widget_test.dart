import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/layout/app_startup_error_widget.dart';

import '../../../shared/pump_shared_ui_widget.dart';
import '../../../shared/translations_setup.dart';

void main() {
  setUpAll(translationsSetup);

  testWidgets('AppStartupErrorWidget retry invokes callback', (tester) async {
    var retried = false;
    await pumpSharedUiWidget(
      tester,
      wrapWithScaffold: false,
      child: AppStartupErrorWidget(
        message: 'Startup failed',
        onRetry: () => retried = true,
      ),
    );
    expect(find.text('Startup failed'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(retried, isTrue);
  });
}
