import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeApiAuthStrategy implements ApiAuthStrategy {
  _FakeApiAuthStrategy(this.token);

  final String token;

  @override
  Future<String> getAccessToken() async => token;
}

void main() {
  group('ApiAuthStrategy', () {
    test('getAccessToken returns the configured token', () async {
      final strategy = _FakeApiAuthStrategy('Bearer test-token');

      await expectLater(
        strategy.getAccessToken(),
        completion('Bearer test-token'),
      );
    });
  });
}
