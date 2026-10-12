import 'package:core/core.dart';
import 'package:flutter/material.dart';

Future<void> translationsSetup() async {
  EasyLocalization.logger.enableBuildModes = const [];

  const locale = Locale('en');
  final translationsMap = await AssetsHelper.populatePkgTrans(
    pkgAssetTransNames: ['shared_ui', kCorePkgName],
    locale: locale,
    trans: {},
  );

  Localization.load(locale, translations: Translations(translationsMap));
}
