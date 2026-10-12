import 'package:core/utils/locale_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('defaults to English when localization missing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            expect(
              LocaleHelper.localiseInput(
                context: context,
                inputEn: 'Hello',
                inputDe: 'Hallo',
              ),
              'Hello',
            );
            expect(LocaleHelper.getCurrentLangCode(context: context), 'en');
            return const SizedBox();
          },
        ),
      ),
    );
  });

  testWidgets('localiseInput picks German when locale is de', (tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('de')],
        path: 'assets/translations',
        startLocale: const Locale('de'),
        fallbackLocale: const Locale('en'),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: Builder(
                builder: (context) {
                  expect(
                    LocaleHelper.localiseInput(
                      context: context,
                      inputEn: 'Hello',
                      inputDe: 'Hallo',
                    ),
                    'Hallo',
                  );
                  expect(
                    LocaleHelper.getCurrentLangCode(context: context),
                    'de',
                  );
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  });

  testWidgets('localiseInput falls back to English for unknown locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr')],
        path: 'assets/translations',
        startLocale: const Locale('fr'),
        fallbackLocale: const Locale('en'),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: Builder(
                builder: (context) {
                  expect(
                    LocaleHelper.localiseInput(
                      context: context,
                      inputEn: 'Hello',
                      inputDe: 'Hallo',
                    ),
                    'Hello',
                  );
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  });
}
