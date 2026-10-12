import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    GoogleFonts.config.allowRuntimeFetching = true;
  });

  group('GoogleFontsConfig.init', () {
    test(
      'sets runtime fetching and skips licences when path is null',
      () async {
        const config = GoogleFontsConfig(allowRuntimeFetching: false);

        await config.init();

        expect(GoogleFonts.config.allowRuntimeFetching, isFalse);
      },
    );

    test('registers licences when a font licence path is provided', () async {
      final config = GoogleFontsConfig(
        fontLicencesAbsPath: 'assets/translations',
        assetListLoader: ({required String path}) async => [
          'assets/translations/en.json',
        ],
      );

      await config.init();
      final license = await LicenseRegistry.licenses.first;
      expect(license.packages, contains('en'));
    });
  });
}
