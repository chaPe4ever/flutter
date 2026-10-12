import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_ui/features/licences_viewer/controllers/licences_page_controller.dart';
import 'package:shared_ui/features/licences_viewer/pages/licences_page.dart';

import '../../../shared/go_router_mocks.dart';
import '../../../shared/pump_shared_ui_widget.dart';
import '../../../shared/translations_setup.dart';

const _defaultPadding = EdgeInsets.all(20);
const _customPadding = EdgeInsets.fromLTRB(4, 6, 8, 10);

List<LicenseEntry> _licences() {
  return const [
    LicenseEntryWithLineBreaks(
      <String>['alpha', 'beta'],
      'First paragraph\n\nSecond paragraph',
    ),
    LicenseEntryWithLineBreaks(<String>['gamma'], 'Solo'),
  ];
}

void _ignoreListTileInkAssertion() {
  final previous = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains(
      'ListTile background color or ink splashes may be invisible',
    )) {
      return;
    }
    previous?.call(details);
  };
  addTearDown(() => FlutterError.onError = previous);
}

void main() {
  setUpAll(translationsSetup);

  testWidgets('shows a progress indicator while licences load', (tester) async {
    await pumpSharedUiWidget(
      tester,
      settle: false,
      overrides: [
        fetchLicencesPod.overrideWith(
          (ref) => Completer<List<LicenseEntry>>().future,
        ),
      ],
      child: const LicencesPage(),
    );

    expect(find.text('Licences'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Padding && widget.padding == _defaultPadding,
      ),
      findsOneWidget,
    );
  });

  testWidgets('lists licences and expands package paragraphs', (tester) async {
    _ignoreListTileInkAssertion();
    await pumpSharedUiWidget(
      tester,
      overrides: [
        fetchLicencesPod.overrideWith((ref) async => _licences()),
      ],
      child: const LicencesPage(padding: _customPadding),
    );

    expect(find.text('Licences'), findsWidgets);
    expect(find.text('alpha, beta'), findsOneWidget);
    expect(find.text('gamma'), findsOneWidget);

    await tester.tap(find.text('alpha, beta'));
    await tester.pumpAndSettle();
    expect(find.text('First paragraph'), findsOneWidget);
    expect(find.text('Second paragraph'), findsOneWidget);

    await tester.tap(find.text('gamma'));
    await tester.pumpAndSettle();
    expect(find.text('Solo'), findsOneWidget);
    expect(find.byKey(const Key('0')), findsOneWidget);
    expect(find.byKey(const Key('1')), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Padding && widget.padding == _customPadding,
      ),
      findsOneWidget,
    );
  });

  testWidgets('close invokes context.pop', (tester) async {
    _ignoreListTileInkAssertion();
    final router = stubbedGoRouter();

    await pumpSharedUiWidget(
      tester,
      mockGoRouter: router,
      overrides: [
        fetchLicencesPod.overrideWith((ref) async => _licences()),
      ],
      child: const LicencesPage(),
    );

    expect(find.text('Licences'), findsWidgets);
    await tester.tap(find.text('Close'));
    await tester.pump(const Duration(milliseconds: 300));

    verify(() => router.pop<Object?>(any<Object?>())).called(1);
  });
}
