import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeConfig implements ConfigBase {
  _FakeConfig(this.id);

  final int id;
  static final List<int> initOrder = [];

  @override
  Future<void> init() async {
    initOrder.add(id);
  }
}

void main() {
  tearDown(_FakeConfig.initOrder.clear);

  group('AppConfig.init', () {
    test('initialises every nested config', () async {
      final appConfig = AppConfig(
        configs: [
          _FakeConfig(1),
          _FakeConfig(2),
          _FakeConfig(3),
        ],
      );

      await appConfig.init();

      expect(_FakeConfig.initOrder, [1, 2, 3]);
    });
  });
}
