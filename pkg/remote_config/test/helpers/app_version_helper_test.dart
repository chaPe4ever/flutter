import 'package:flutter_test/flutter_test.dart';
import 'package:remote_config/helpers/app_version_helper.dart';
import 'package:remote_config/models/app_version_model.dart';

import 'firebase_remote_config_test_setup.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);
  tearDown(clearPackageInfoMock);

  test('reads version and build number from package info', () async {
    await mockPackageInfo(version: '2.3.4', buildNumber: '99');

    expect(
      await VersionHelper.appVersion(),
      const AppVersionModel(version: '2.3.4', buildNumber: 99),
    );
  });

  test('uses zero when build number is not numeric', () async {
    await mockPackageInfo(buildNumber: 'not-a-number');

    expect(
      await VersionHelper.appVersion(),
      const AppVersionModel(version: '1.0.0', buildNumber: 0),
    );
  });
}
