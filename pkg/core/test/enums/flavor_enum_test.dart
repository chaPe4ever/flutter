import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FlavorEnum exposes dev, stg, and prod', () {
    expect(
      FlavorEnum.values,
      [FlavorEnum.dev, FlavorEnum.stg, FlavorEnum.prod],
    );
  });
}
