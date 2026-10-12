import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef FontLicenceAssetListLoader =
    Future<List<String>> Function({
      required String path,
    });

class GoogleFontsConfig implements ConfigBase {
  const GoogleFontsConfig({
    this.fontLicencesAbsPath,
    this.allowRuntimeFetching = true,
    FontLicenceAssetListLoader? assetListLoader,
  }) : _assetListLoader = assetListLoader ?? AssetsHelper.getAssetList;

  final String? fontLicencesAbsPath;
  final bool allowRuntimeFetching;
  final FontLicenceAssetListLoader _assetListLoader;
  @override
  Future<void> init() async {
    // Assigning it to true means enable getting fonts using internet
    // conn. When false means get them offline from the google_fonts folder
    GoogleFonts.config.allowRuntimeFetching = allowRuntimeFetching;

    await _googleFontLicencesInit(fontLicencesAbsPath);
  }

  Future<void> _googleFontLicencesInit(String? path) async {
    if (path == null) {
      return Future.value();
    }
    await _assetListLoader(path: path).then((licencePaths) async {
      LicenseRegistry.addLicense(() async* {
        for (final licencePath in licencePaths) {
          final licence = await rootBundle.loadString(licencePath);
          final licenceName = licencePath
              .split('/')
              .toList()
              .last
              .split('.')
              .first;

          yield LicenseEntryWithLineBreaks([licenceName], licence);
        }
      });
    });
  }
}
