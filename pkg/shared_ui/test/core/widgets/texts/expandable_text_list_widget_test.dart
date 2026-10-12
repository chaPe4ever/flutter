import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/texts/expandable_text_list_widget.dart';

import '../../../shared/pump_shared_ui_widget.dart';
import '../../../shared/translations_setup.dart';

void main() {
  setUpAll(translationsSetup);

  testWidgets('ExpandableTextListWidget expands and collapses long lists', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: ExpandableTextListWidget(
        texts: List.generate(5, (i) => 'Line $i'),
      ),
    );
    expect(find.text('More'), findsOneWidget);
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Line 4'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(
      find.ancestor(
        of: find.text('Less'),
        matching: find.byType(ElevatedButton),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('More'), findsOneWidget);
  });

  testWidgets('short list has no more button', (tester) async {
    await pumpSharedUiWidget(
      tester,
      child: const ExpandableTextListWidget(texts: ['Only']),
    );
    expect(find.text('Only'), findsWidgets);
    expect(find.text('More'), findsNothing);
  });
}
