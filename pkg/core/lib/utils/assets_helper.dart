import 'dart:convert';

import 'package:core/extensions/locale_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Assets helper class
class AssetsHelper {
  /// Get an asset list given the [path]. Path normally consists of
  /// packageName and folderName like so: packages/my_package/my_asset_folder
  static Future<List<String>> getAssetList({required String path}) async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final allAssets = assetManifest.listAssets();
    return allAssets.where((asset) => asset.contains(path)).toList();
  }

  /// Populates translations based on the [pkgAssetTransNames] provided
  static Future<Map<String, dynamic>> populatePkgTrans({
    required List<String> pkgAssetTransNames,
    required Locale locale,
    required Map<String, dynamic> trans,
    String assetTransPath = 'assets/translations',
  }) async => Future.wait(
    pkgAssetTransNames
        .map(
          (pkgName) =>
              'packages/$pkgName/$assetTransPath/${locale.toStringWithSeparator(separator: "-")}.json',
        )
        .map((pkgAssetPath) async {
          await rootBundle
              .loadString(pkgAssetPath)
              .then(
                (assetString) =>
                    jsonDecode(assetString) as Map<String, dynamic>,
              )
              .then(
                (assetTransMap) => assetTransMap.forEach(
                  (key, value) =>
                      trans.update(key, (_) => value, ifAbsent: () => value),
                ),
              );
        }),
  ).then((_) => trans);

  /// Populates translations based on the [path] provided
  static Future<Map<String, dynamic>> populateTransFromPath({
    required String path,
    required Map<String, dynamic> trans,
  }) async {
    (json.decode(await rootBundle.loadString(path)) as Map<String, dynamic>)
        .forEach(
          (key, value) =>
              trans.update(key, (_) => value, ifAbsent: () => value),
        );

    return Future.value(trans);
  }
}
