import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';

/// Localization Helper
final class LocaleHelper {
  const LocaleHelper._();

  /// Localise the input. Enrich with additional Locales if required
  static String localiseInput({
    required BuildContext context,
    required String inputEn,
    required String inputDe,
  }) {
    final easyLocalization = EasyLocalization.of(context);
    final currentLocale = easyLocalization?.currentLocale ?? const Locale('en');

    switch (currentLocale.languageCode) {
      case 'en':
        return inputEn;
      case 'de':
        return inputDe;
      default:
        return inputEn;
    }
  }

  static String getCurrentLangCode({required BuildContext context}) {
    final easyLocalization = EasyLocalization.of(context);
    final currentLocale = easyLocalization?.currentLocale ?? const Locale('en');

    return currentLocale.languageCode;
  }
}
