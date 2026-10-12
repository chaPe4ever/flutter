import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

final class _RecordingConfig implements ConfigBase {
  _RecordingConfig(this.label);

  final String label;
  final List<String> initLog = [];

  @override
  Future<void> init() async {
    initLog.add(label);
  }
}

void main() {
  test('ConfigBase implementations expose init', () async {
    final config = _RecordingConfig('a');
    await config.init();
    expect(config.initLog, ['a']);
  });
}
