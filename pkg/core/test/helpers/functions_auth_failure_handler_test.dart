import 'package:core/helpers/functions_auth_failure_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(FunctionsAuthFailureHandler.reset);

  test('reset clears onUnauthenticated', () {
    var called = false;
    FunctionsAuthFailureHandler.onUnauthenticated = () {
      called = true;
    };
    FunctionsAuthFailureHandler.reset();
    FunctionsAuthFailureHandler.onUnauthenticated?.call();
    expect(called, isFalse);
  });
}
