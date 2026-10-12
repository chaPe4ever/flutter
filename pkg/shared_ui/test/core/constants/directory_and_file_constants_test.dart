import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/constants/directory_and_file_constants.dart';

void main() {
  test('shared asset path constants', () {
    expect(kSharedUiPkgName, 'shared_ui');
    expect(kAssetLicences, 'assets/licences');
    expect(kAssetTranslations, 'assets/translations');
  });
}
