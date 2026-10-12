import 'package:flutter_test/flutter_test.dart';
import 'package:remote_config/extensions/app_version_extensions.dart';
import 'package:remote_config/models/app_version_model.dart';

void main() {
  group('AppVersionModelX.splitVersion', () {
    test('splits semver segments', () {
      const model = AppVersionModel(version: '1.2.3', buildNumber: 1);
      expect(model.splitVersion, ['1', '2', '3']);
    });
  });

  group('AppVersionModelX.toStringFormat', () {
    test('includes version and build number', () {
      const model = AppVersionModel(version: '2.0.0', buildNumber: 42);
      expect(model.toStringFormat, '2.0.0 (42)');
    });
  });

  group('AppVersionModelX.checkIfUpdateIsAvailable', () {
    test('returns false when segment counts differ', () {
      const current = AppVersionModel(version: '1.0', buildNumber: 1);
      const remote = AppVersionModel(version: '1.0.0', buildNumber: 1);
      expect(current.checkIfUpdateIsAvailable(remote), isFalse);
    });

    test('returns false when current has more than three segments', () {
      const current = AppVersionModel(version: '1.0.0.0', buildNumber: 1);
      const remote = AppVersionModel(version: '1.0.0', buildNumber: 1);
      expect(current.checkIfUpdateIsAvailable(remote), isFalse);
    });

    test('returns true when a major segment is lower', () {
      const current = AppVersionModel(version: '1.0.0', buildNumber: 5);
      const remote = AppVersionModel(version: '2.0.0', buildNumber: 1);
      expect(current.checkIfUpdateIsAvailable(remote), isTrue);
    });

    test('returns true when a minor segment is lower', () {
      const current = AppVersionModel(version: '1.1.0', buildNumber: 1);
      const remote = AppVersionModel(version: '1.2.0', buildNumber: 1);
      expect(current.checkIfUpdateIsAvailable(remote), isTrue);
    });

    test('returns true when a patch segment is lower', () {
      const current = AppVersionModel(version: '1.0.1', buildNumber: 1);
      const remote = AppVersionModel(version: '1.0.2', buildNumber: 1);
      expect(current.checkIfUpdateIsAvailable(remote), isTrue);
    });

    test('returns false when remote segment is lower', () {
      const current = AppVersionModel(version: '2.0.0', buildNumber: 1);
      const remote = AppVersionModel(version: '1.9.9', buildNumber: 99);
      expect(current.checkIfUpdateIsAvailable(remote), isFalse);
    });

    test('ignores environment suffix on current version segments', () {
      const current = AppVersionModel(version: '1.0.0-beta', buildNumber: 1);
      const remote = AppVersionModel(version: '1.0.1', buildNumber: 1);
      expect(current.checkIfUpdateIsAvailable(remote), isTrue);
    });

    test('treats non-numeric segments as zero', () {
      const current = AppVersionModel(version: 'a.b.c', buildNumber: 1);
      const remote = AppVersionModel(version: '0.0.1', buildNumber: 1);
      expect(current.checkIfUpdateIsAvailable(remote), isTrue);
    });

    test('compares build numbers when semver matches', () {
      const current = AppVersionModel(version: '1.0.0', buildNumber: 1);
      const remote = AppVersionModel(version: '1.0.0', buildNumber: 2);
      expect(current.checkIfUpdateIsAvailable(remote), isTrue);
    });

    test('returns false when semver and build number match', () {
      const current = AppVersionModel(version: '1.0.0', buildNumber: 10);
      const remote = AppVersionModel(version: '1.0.0', buildNumber: 10);
      expect(current.checkIfUpdateIsAvailable(remote), isFalse);
    });
  });
}
