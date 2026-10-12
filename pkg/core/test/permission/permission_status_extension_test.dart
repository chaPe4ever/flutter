import 'package:core/permission/permission_base.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  group('PermissionStatusX', () {
    test('maps every permission_handler status to core status', () {
      expect(
        PermissionStatus.denied.toCorePermissionStatus,
        CorePermissionStatus.denied,
      );
      expect(
        PermissionStatus.granted.toCorePermissionStatus,
        CorePermissionStatus.granted,
      );
      expect(
        PermissionStatus.restricted.toCorePermissionStatus,
        CorePermissionStatus.restricted,
      );
      expect(
        PermissionStatus.limited.toCorePermissionStatus,
        CorePermissionStatus.limited,
      );
      expect(
        PermissionStatus.permanentlyDenied.toCorePermissionStatus,
        CorePermissionStatus.permanentlyDenied,
      );
      expect(
        PermissionStatus.provisional.toCorePermissionStatus,
        CorePermissionStatus.provisional,
      );
    });
  });
}
