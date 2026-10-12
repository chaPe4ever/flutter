import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:remote_config/models/app_maintenance_model.dart';

void main() {
  group('AppMaintenanceModel', () {
    test('def factory is inactive', () {
      expect(
        AppMaintenanceModel.def(),
        const AppMaintenanceModel(isActive: false),
      );
    });

    test('fromMap defaults isActive to false', () {
      expect(
        AppMaintenanceModel.fromMap(const {}),
        const AppMaintenanceModel(isActive: false),
      );
    });

    test('round-trips through map and json', () {
      const model = AppMaintenanceModel(isActive: true);
      expect(AppMaintenanceModel.fromMap(model.toMap()), model);
      expect(
        AppMaintenanceModel.fromJson(model.toJson()),
        model,
      );
      expect(json.decode(model.toJson()), model.toMap());
    });

    test('copyWith overrides isActive', () {
      const model = AppMaintenanceModel(isActive: false);
      expect(
        model.copyWith(isActive: true),
        const AppMaintenanceModel(isActive: true),
      );
    });

    test('props include isActive', () {
      const a = AppMaintenanceModel(isActive: true);
      const b = AppMaintenanceModel(isActive: false);
      expect(a == b, isFalse);
    });
  });
}
