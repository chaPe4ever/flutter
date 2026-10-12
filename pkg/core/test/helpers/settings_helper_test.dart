import 'package:core/helpers/settings_helper.dart';
import 'package:core/storage/local_storage_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStorage implements LocalStorageBase {
  final Map<String, dynamic> store = {};

  @override
  Future<void> write(String key, dynamic value) async {
    store[key] = value;
  }

  @override
  Future<T?> read<T>(String key) async => store[key] as T?;

  @override
  Future<void> remove(String key) async {
    store.remove(key);
  }

  @override
  Future<void> erase() async {
    store.clear();
  }

  @override
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback) => () {};
}

void main() {
  group('SettingsHelper.init', () {
    test('writes defaults only for missing keys', () async {
      final storage = _FakeStorage();
      await storage.write('existing', 'keep');

      await SettingsHelper.init(
        storage: storage,
        settingExtras: {
          'existing': 'replace',
          'newKey': 42,
        },
      );

      expect(storage.store['existing'], 'keep');
      expect(storage.store['newKey'], 42);
    });

    test('does nothing when settingExtras is null', () async {
      final storage = _FakeStorage();
      await SettingsHelper.init(storage: storage);
      expect(storage.store, isEmpty);
    });
  });
}
