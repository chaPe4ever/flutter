import 'package:core/utils/debounce.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Debounce delays callback', () async {
    const debounce = Debounce(duration: Duration(milliseconds: 50));
    var count = 0;
    debounce(() => count++);
    debounce(() => count++);
    expect(count, 0);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(count, 1);
    debounce.cancel();
  });

  test('createDebouncedCallback returns null for null onTap', () {
    expect(createDebouncedCallback(null), isNull);
  });

  test('createDebouncedCallback invokes debounced onTap', () async {
    var taps = 0;
    final callback = createDebouncedCallback(
      () => taps++,
      debounce: const Debounce(duration: Duration(milliseconds: 30)),
    );
    expect(callback, isNotNull);
    callback!();
    callback();
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(taps, 1);
  });
}
