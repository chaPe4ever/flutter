import 'package:crashlytics/contracts/crashlytics_base.dart';
import 'package:crashlytics/implementations/fake_crashlytics_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FakeCrashlyticsImpl satisfies CrashlyticsBase', () {
    expect(FakeCrashlyticsImpl(), isA<CrashlyticsBase>());
  });
}
