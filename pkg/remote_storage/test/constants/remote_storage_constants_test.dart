import 'package:flutter_test/flutter_test.dart';
import 'package:remote_storage/constants/remote_storage_constants.dart';

void main() {
  test('kRemoteStoragePkgName matches the package name', () {
    expect(kRemoteStoragePkgName, 'remote_storage');
  });
}
