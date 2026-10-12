import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/bars/app_tab_bar.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('AppTabBar builds tabs and handles onTap', (tester) async {
    var tapped = -1;
    await pumpSharedUiWidget(
      tester,
      wrapWithScaffold: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: AppTabBar(
              tabs: const ['One', 'Two'],
              onTap: (i) => tapped = i,
            ),
          ),
        ),
      ),
    );
    expect(find.text('One'), findsOneWidget);
    await tester.tap(find.text('Two'));
    await tester.pump();
    expect(tapped, 1);
  });

  testWidgets('AppTabBar scrollable when more than five tabs', (tester) async {
    await pumpSharedUiWidget(
      tester,
      wrapWithScaffold: false,
      child: Material(
        child: AppTabBar(
          tabs: List.generate(6, (i) => 'Tab $i'),
        ),
      ),
    );
    expect(find.byType(TabBar), findsOneWidget);
    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    expect(tabBar.isScrollable, isTrue);
  });
}
