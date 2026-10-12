import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

export 'mock_firebase_remote_config.dart';

Future<void> mockPackageInfo({
  String version = '1.0.0',
  String buildNumber = '1',
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  PackageInfo.setMockInitialValues(
    appName: 'Test',
    packageName: 'com.test.app',
    version: version,
    buildNumber: buildNumber,
    buildSignature: '',
  );
}

void clearPackageInfoMock() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PackageInfo.setMockInitialValues(
    appName: 'Test',
    packageName: 'com.test.app',
    version: '1.0.0',
    buildNumber: '0',
    buildSignature: '',
  );
}
