import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('localStoragePod', () {
    test('delegates read and write to the underlying storage', () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final storage = container.read(localStoragePod.notifier);

      await storage.write('key', 'value');
      expect(await storage.read<String>('key'), 'value');

      var notified = 0;
      final remove = storage.listenKey('key', (_) => notified++);
      await storage.write('key', 'next');
      expect(notified, 1);
      remove();

      await storage.remove('key');
      expect(await storage.read<String>('key'), isNull);

      await storage.erase();
      expect(await storage.read<String>('key'), isNull);
    });
  });
}
