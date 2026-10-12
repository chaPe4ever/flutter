import 'package:core/core.dart';
import 'package:core/permission/permission_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('permissionPod', () {
    test('provides PermissionImpl', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(permissionPod), isA<PermissionImpl>());
    });
  });
}
