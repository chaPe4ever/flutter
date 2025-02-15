import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Custom asset loader used for loading translations from multiple packages
class AssetLoaderHelper extends AssetLoader {
  /// Ctr
  const AssetLoaderHelper({required this.pkgAssetTransNames});

  final List<String> pkgAssetTransNames;

  static final Completer<void> completer = Completer<void>();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async =>
      AssetsHelper.populatePkgTrans(
        pkgAssetTransNames: pkgAssetTransNames,
        locale: locale,
        trans: {},
      )
          .then(
        (trans) async => AssetsHelper.populateTransFromPath(
          path: '$path/${locale.toStringWithSeparator(separator: "-")}.json',
          trans: trans,
        ),
      )
          .then((trans) {
        completer.complete();
        return trans;
      });
}
