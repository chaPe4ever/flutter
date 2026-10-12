import 'package:core/utils/assets_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AssetsHelper', () {
    test('populateTransFromPath merges bundled json into map', () async {
      final trans = <String, dynamic>{'existing': 'stay'};
      final result = await AssetsHelper.populateTransFromPath(
        path: 'assets/translations/en.json',
        trans: trans,
      );

      expect(result['existing'], 'stay');
      expect(result, isNotEmpty);
    });

    test('getAssetList filters assets by path', () async {
      final assets = await AssetsHelper.getAssetList(
        path: 'assets/translations',
      );

      expect(assets, isNotEmpty);
      expect(
        assets.every((asset) => asset.contains('assets/translations')),
        isTrue,
      );
    });

    test('populatePkgTrans merges package translation assets', () async {
      final result = await AssetsHelper.populatePkgTrans(
        pkgAssetTransNames: const ['core'],
        locale: const Locale('en'),
        trans: <String, dynamic>{},
      );

      expect(result, isNotEmpty);
    });
  });
}
