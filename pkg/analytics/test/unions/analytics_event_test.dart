import 'package:analytics/unions/analytics_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseAnalyticsEvent', () {
    test('stores name and optional parameters', () {
      const parameters = {'screen': 'home'};

      final event = FirebaseAnalyticsEvent(
        name: 'open_screen',
        parameters: parameters,
      );

      expect(event.name, 'open_screen');
      expect(event.parameters, same(parameters));
    });

    test('allows null parameters', () {
      final event = FirebaseAnalyticsEvent(name: 'tap');

      expect(event.name, 'tap');
      expect(event.parameters, isNull);
    });
  });
}
