import 'package:core/core.dart';

abstract final class LocaleHelper {
  static String localiseInput({
    required BuildContext context,
    required String inputEn,
    required String inputDe,
  }) {
    final languageCode = localeOf(context).languageCode;
    if (languageCode == 'de') {
      return inputDe;
    }
    return inputEn;
  }

  static String getCurrentLangCode({required BuildContext context}) {
    return localeOf(context).languageCode;
  }

  static Locale localeOf(BuildContext context) {
    return localeOrEnglish(EasyLocalization.of(context)?.currentLocale);
  }

  static Locale localeOrEnglish(Locale? locale) => locale ?? const Locale('en');
}
