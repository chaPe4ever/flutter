import 'package:core/core.dart';
import 'package:core/permission/permission_impl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _permissionsChannel = MethodChannel(
  'flutter.baseflow.com/permissions/methods',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_permissionsChannel, _mockPermissionsHandler);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_permissionsChannel, null);
  });

  group('PermissionImpl', () {
    test(
      'getOrRequestPermissionStatus covers every core permission type',
      () async {
        final impl = PermissionImpl();

        for (final type in CorePermissionType.values) {
          final status = await impl.getOrRequestPermissionStatus(type);
          expect(status, CorePermissionStatus.granted);
        }
      },
    );

    test('openAppSystemAppSettings returns platform result', () async {
      final impl = PermissionImpl();

      expect(await impl.openAppSystemAppSettings(), isTrue);
    });
  });
}

Future<dynamic> _mockPermissionsHandler(MethodCall call) async {
  switch (call.method) {
    case 'requestPermissions':
      final permissionIds = (call.arguments as List<dynamic>).cast<int>();
      return {for (final id in permissionIds) id: 1};
    case 'openAppSettings':
      return true;
    default:
      return null;
  }
}
