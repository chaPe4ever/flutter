import 'package:core/utils/in_memory_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InMemoryStore', () {
    test('streams seeded value and updates', () async {
      final store = InMemoryStore<int>(1);
      expect(store.value, 1);
      expect(await store.stream.first, 1);

      store.value = 2;
      expect(store.value, 2);
      expect(await store.stream.first, 2);

      store.close();
    });
  });

  group('InMemoryBroadcast', () {
    test('broadcasts added values', () async {
      final broadcast = InMemoryBroadcast<String>();
      final events = <String>[];
      final sub = broadcast.stream.listen(events.add);

      broadcast
        ..add('a')
        ..add('b');
      await Future<void>.delayed(Duration.zero);
      expect(events, ['a', 'b']);

      await sub.cancel();
      broadcast.close();
    });
  });
}
