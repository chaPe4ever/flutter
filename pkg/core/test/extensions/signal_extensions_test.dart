import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoolSignalX', () {
    test('toggle flips signal value', () {
      final signal = Signal(false)..toggle();
      expect(signal.value, isTrue);
      signal.toggle();
      expect(signal.value, isFalse);
      signal.dispose();
    });
  });
}
