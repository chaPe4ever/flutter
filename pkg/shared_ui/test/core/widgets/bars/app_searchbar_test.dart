import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/bars/app_searchbar.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppSearchbar shows search icon then clear control', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    String? changed;
    var cleared = false;

    await pumpSharedUiWidget(
      tester,
      child: AppSearchbar(
        controller: controller,
        hintText: 'Search',
        onChanged: (v) => changed = v,
        onClearTap: () => cleared = true,
      ),
    );
    expect(find.byIcon(Icons.search), findsOneWidget);
    await tester.enterText(find.byType(SearchBar), 'abc');
    await tester.pump(const Duration(milliseconds: 300));
    expect(changed, 'abc');
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.cancel_outlined));
    await tester.pump(const Duration(milliseconds: 400));
    expect(cleared, isTrue);
    expect(controller.text, isEmpty);
  });

  testWidgets('AppSearchbar unfocuses on submit and tap outside', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: AppSearchbar(onChanged: (_) {}),
    );
    final searchBar = tester.widget<SearchBar>(find.byType(SearchBar));
    searchBar.onSubmitted!('query');
    searchBar.onTapOutside!(const PointerDownEvent());
    await tester.pump();
  });
}
