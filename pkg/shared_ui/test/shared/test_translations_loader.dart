import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Loads `assets/translations/{locale}.json` for widget tests.
class TestTranslationsLoader extends AssetLoader {
  const TestTranslationsLoader();

  static final Map<String, Map<String, dynamic>> _cache = {};

  static Future<Map<String, dynamic>> loadLocale(Locale locale) async {
    final code = locale.languageCode;
    final cached = _cache[code];
    if (cached != null) {
      return cached;
    }

    Future<Map<String, dynamic>> fromPath(String path) {
      return AssetsHelper.populateTransFromPath(path: path, trans: {});
    }

    try {
      final map = await fromPath('assets/translations/$code.json');
      return _cache[code] = map;
    } on Object {
      if (code == 'en') {
        rethrow;
      }
      final fallback = await loadLocale(const Locale('en'));
      return _cache[code] = Map<String, dynamic>.of(fallback);
    }
  }

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return loadLocale(locale);
  }
}
