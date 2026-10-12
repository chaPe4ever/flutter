import 'package:core/storage/local_storage_shared_prefs_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageSharedPreferenceImpl', () {
    late LocalStorageSharedPreferenceImpl storage;

    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      storage = LocalStorageSharedPreferenceImpl();
    });

    test('writes and reads supported types', () async {
      await storage.write('str', 'hello');
      await storage.write('int', 7);
      await storage.write('bool', true);
      await storage.write('double', 1.5);
      await storage.write('list', <String>['a', 'b']);

      expect(await storage.read<String>('str'), 'hello');
      expect(await storage.read<int>('int'), 7);
      expect(await storage.read<bool>('bool'), isTrue);
      expect(await storage.read<double>('double'), 1.5);
      expect(await storage.read<List<String>>('list'), ['a', 'b']);
    });

    test('returns null for unsupported read types', () async {
      await storage.write('str', 'hello');

      expect(await storage.read<Map<String, dynamic>>('str'), isNull);
    });

    test('remove clears value and notifies listeners', () async {
      await storage.write('token', 'abc');
      dynamic lastValue = 'unset';
      final removeListener = storage.listenKey('token', (value) {
        lastValue = value;
      });

      await storage.remove('token');

      expect(await storage.read<String>('token'), isNull);
      expect(lastValue, isNull);

      removeListener();
    });

    test('listenKey unsubscribe stops notifications', () async {
      var notifications = 0;
      final removeListener = storage.listenKey('key', (_) {
        notifications++;
      });

      await storage.write('key', 'v1');
      removeListener();
      await storage.write('key', 'v2');

      expect(notifications, 1);
    });

    test('erase clears stored values', () async {
      await storage.write('a', '1');
      await storage.write('b', '2');

      await storage.erase();

      expect(await storage.read<String>('a'), isNull);
      expect(await storage.read<String>('b'), isNull);
    });
  });
}
