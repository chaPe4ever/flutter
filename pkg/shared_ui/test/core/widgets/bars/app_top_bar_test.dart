import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_ui/core/widgets/bars/app_top_bar.dart';
import 'package:shared_ui/core/widgets/buttons/app_icon_button.dart';

import '../../../shared/go_router_mocks.dart';
import '../../../shared/pump_shared_ui_widget.dart';
import '../../../shared/translations_setup.dart';

void main() {
  setUpAll(translationsSetup);

  group('AppTopBar', () {
    testWidgets('parent route hides back button', (tester) async {
      await pumpSharedUiWidget(
        tester,
        mockGoRouter: stubbedGoRouter(),
        child: const AppTopBar(title: 'Home'),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(AppIconButton), findsNothing);
    });

    testWidgets('nested route shows back and pops', (tester) async {
      final router = stubbedGoRouter(path: '/nested/page');
      await pumpSharedUiWidget(
        tester,
        mockGoRouter: router,
        child: const AppTopBar(title: 'Nested'),
      );
      await tester.tap(find.byType(AppIconButton));
      await tester.pump(const Duration(milliseconds: 300));
      verify(() => router.pop<Object?>(any<Object?>())).called(1);
    });

    testWidgets('isParentPage override and custom chrome', (tester) async {
      const bar = AppTopBar(
        title: 'Custom',
        isParentPage: false,
        leading: Icon(Icons.star),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(8),
          child: SizedBox(height: 8),
        ),
        shape: RoundedRectangleBorder(),
        customRreferredSize: Size.fromHeight(80),
      );
      expect(bar.preferredSize.height, 80);
      await pumpSharedUiWidget(
        tester,
        mockGoRouter: stubbedGoRouter(),
        child: bar,
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('appTopBarActions', () {
    testWidgets('UserAction and ChatAction invoke onTap', (tester) async {
      var userTapped = false;
      var chatTapped = false;
      await pumpSharedUiWidget(
        tester,
        mockGoRouter: stubbedGoRouter(),
        child: AppTopBar(
          title: 'Actions',
          actions: appTopBarActions(
            userActionModel: ActionModel(
              onTap: () => userTapped = true,
              icon: const Icon(Icons.person),
            ),
            chatActionModel: ActionModel(
              onTap: () => chatTapped = true,
              icon: const Icon(Icons.chat),
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.person));
      await tester.pump(const Duration(milliseconds: 300));
      expect(userTapped, isTrue);
      await tester.tap(find.byIcon(Icons.chat));
      await tester.pump(const Duration(milliseconds: 300));
      expect(chatTapped, isTrue);
    });

    testWidgets('default icons when model has no custom icon', (tester) async {
      await pumpSharedUiWidget(
        tester,
        mockGoRouter: stubbedGoRouter(),
        child: const AppTopBar(
          title: 'Defaults',
          actions: [
            UserAction(),
            ChatAction(),
          ],
        ),
      );
      expect(find.byType(UserAction), findsOneWidget);
      expect(find.byType(ChatAction), findsOneWidget);
    });

    test('ActionModel props', () {
      const a = ActionModel(onTap: _noop, icon: Icon(Icons.add));
      const b = ActionModel(onTap: _noop, icon: Icon(Icons.book));
      expect(a.props, isNot(equals(b.props)));
    });
  });
}

void _noop() {}
