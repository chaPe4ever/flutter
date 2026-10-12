import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppModeEnum exposes fake and real', () {
    expect(AppModeEnum.values, [AppModeEnum.fake, AppModeEnum.real]);
  });
}
