import 'package:analytics/contracts/analytics_base.dart';
import 'package:analytics/implementations/fake_analytics_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FakeAnalyticsImpl satisfies AnalyticsBase', () {
    expect(FakeAnalyticsImpl(), isA<AnalyticsBase>());
  });
}
