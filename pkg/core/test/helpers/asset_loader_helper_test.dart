import 'package:core/helpers/asset_loader_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AssetLoaderHelper', () {
    test('load merges translations and notifies listeners', () async {
      // Survive randomized suite order if dispose() ran earlier.
      AssetLoaderHelper.dispose();

      const loader = AssetLoaderHelper(pkgAssetTransNames: []);
      final localeFuture = AssetLoaderHelper.onTranslationsLoaded.first;

      final result = await loader.load(
        'assets/translations',
        const Locale('en'),
      );

      expect(result, isNotEmpty);
      await expectLater(localeFuture, completion(const Locale('en')));
      expect(AssetLoaderHelper.isInitialLoadComplete, isTrue);
    });

    test('load returns empty map when translation file is missing', () async {
      const loader = AssetLoaderHelper(pkgAssetTransNames: []);

      final result = await loader.load(
        'assets/translations/missing',
        const Locale('en'),
      );

      expect(result, isEmpty);
    });
  });
}
