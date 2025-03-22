import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Custom asset loader used for loading translations from multiple packages
class AssetLoaderHelper extends AssetLoader {
  /// Ctr
  const AssetLoaderHelper({required this.pkgAssetTransNames});

  final List<String> pkgAssetTransNames;

  // Replace the static completer with a static flag
  static bool isInitialLoadComplete = false;

  // Create a notification stream for translation loads
  static final StreamController<Locale> _onTranslationsLoaded =
      StreamController<Locale>.broadcast();

  // Public stream that others can listen to
  static Stream<Locale> get onTranslationsLoaded =>
      _onTranslationsLoaded.stream;

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    try {
      // First load translations from packages
      final trans = await AssetsHelper.populatePkgTrans(
        pkgAssetTransNames: pkgAssetTransNames,
        locale: locale,
        trans: {},
      );

      // Then load translations from main path
      final result = await AssetsHelper.populateTransFromPath(
        path: '$path/${locale.toStringWithSeparator(separator: "-")}.json',
        trans: trans,
      );

      // Notify listeners of loaded translations
      _onTranslationsLoaded.add(locale);

      // Set initial load flag if it's the first time
      if (!isInitialLoadComplete) {
        isInitialLoadComplete = true;
      }

      return result;
    } catch (e) {
      Log.error('Error loading translations: $e');
      return {};
    }
  }

  // Call this method when disposing the app
  static void dispose() {
    _onTranslationsLoaded.close();
  }
}
