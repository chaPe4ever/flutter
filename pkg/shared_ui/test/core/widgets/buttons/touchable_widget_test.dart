import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/buttons/touchable_widget.dart';
import 'package:shared_ui/core/widgets/loading/app_loading_indicator.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('TouchableWidget runs async tap and shows busy indicator', (
    tester,
  ) async {
    var completed = false;
    await pumpSharedUiWidget(
      tester,
      settle: false,
      child: TouchableWidget(
        onTap: () async {
          await Future<void>.delayed(const Duration(milliseconds: 80));
          completed = true;
        },
        child: const Text('tap-me'),
      ),
    );
    await tester.tap(find.text('tap-me'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(AppLoadingIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();
    expect(completed, isTrue);
  });

  testWidgets('TouchableWidget can hide busy overlay', (tester) async {
    await pumpSharedUiWidget(
      tester,
      settle: false,
      child: TouchableWidget(
        showIsBusy: false,
        onTap: () async {},
        child: const Text('quiet'),
      ),
    );
    await tester.tap(find.text('quiet'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(AppLoadingIndicator), findsNothing);
  });
}
