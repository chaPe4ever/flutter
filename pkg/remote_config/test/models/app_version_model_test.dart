import 'package:flutter_test/flutter_test.dart';
import 'package:remote_config/models/app_version_model.dart';

void main() {
  group('AppVersionModel', () {
    test('round-trips through json', () {
      const model = AppVersionModel(version: '1.2.3', buildNumber: 7);
      final decoded = AppVersionModel.fromJson(model.toJson());
      expect(decoded, model);
    });

    test('copyWith overrides provided fields', () {
      const model = AppVersionModel(version: '1.0.0', buildNumber: 1);
      expect(
        model.copyWith(version: '2.0.0', buildNumber: 2),
        const AppVersionModel(version: '2.0.0', buildNumber: 2),
      );
      expect(
        model.copyWith(version: '2.0.0'),
        const AppVersionModel(version: '2.0.0', buildNumber: 1),
      );
      expect(
        model.copyWith(buildNumber: 9),
        const AppVersionModel(version: '1.0.0', buildNumber: 9),
      );
    });

    test('props include version and build number', () {
      const a = AppVersionModel(version: '1.0.0', buildNumber: 1);
      const b = AppVersionModel(version: '1.0.0', buildNumber: 2);
      expect(a == b, isFalse);
    });
  });

  group('AppVersionRemoteModel', () {
    test('def factory matches expected defaults', () {
      expect(
        AppVersionRemoteModel.def(),
        const AppVersionRemoteModel(
          version: '1.0.0',
          buildNumber: 1,
          isOptional: true,
        ),
      );
    });

    test('round-trips through json', () {
      const model = AppVersionRemoteModel(
        version: '3.1.4',
        buildNumber: 15,
        isOptional: false,
      );
      final decoded = AppVersionRemoteModel.fromJson(model.toJson());
      expect(decoded, model);
    });

    test('copyWith overrides isOptional', () {
      const model = AppVersionRemoteModel(
        version: '1.0.0',
        buildNumber: 1,
        isOptional: true,
      );
      expect(
        model.copyWith(isOptional: false),
        const AppVersionRemoteModel(
          version: '1.0.0',
          buildNumber: 1,
          isOptional: false,
        ),
      );
      expect(model.copyWith(version: '2.0.0').isOptional, isTrue);
    });
  });

  group('AppVersionUpdateModel', () {
    test('def factory matches expected defaults', () {
      expect(
        AppVersionUpdateModel.def(),
        const AppVersionUpdateModel(
          version: '1.0.0',
          buildNumber: 1,
          isOptional: true,
          isUpdateAvailable: false,
        ),
      );
    });

    test('round-trips through json', () {
      const model = AppVersionUpdateModel(
        version: '4.0.0',
        buildNumber: 40,
        isOptional: false,
        isUpdateAvailable: true,
      );
      final decoded = AppVersionUpdateModel.fromJson(model.toJson());
      expect(decoded, model);
    });

    test('copyWith overrides update flag', () {
      const model = AppVersionUpdateModel(
        version: '1.0.0',
        buildNumber: 1,
        isOptional: true,
        isUpdateAvailable: false,
      );
      expect(
        model.copyWith(isUpdateAvailable: true),
        const AppVersionUpdateModel(
          version: '1.0.0',
          buildNumber: 1,
          isOptional: true,
          isUpdateAvailable: true,
        ),
      );
      expect(
        model.copyWith(isOptional: false).isUpdateAvailable,
        isFalse,
      );
    });
  });
}
