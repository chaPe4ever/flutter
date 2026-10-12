import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EitherX', () {
    test('getOrCrash returns right value', () {
      expect(right<CoreException, int>(7).getOrCrash(), 7);
    });

    test('getOrCrash throws left', () {
      const leftValue = NoNetworkException();
      expect(
        () => left<CoreException, int>(leftValue).getOrCrash(),
        throwsA(same(leftValue)),
      );
    });

    test('getOrThrow maps right', () {
      expect(
        right<CoreException, int>(3).getOrThrow((r) => r * 2),
        6,
      );
    });
  });

  group('OptionX on Future', () {
    test('toEitherUnit maps none to right unit', () async {
      final result = await Future.value(none<CoreException>()).toEitherUnit();
      expect(result, right<CoreException, Unit>(unit));
    });

    test('toEitherUnit maps some to left', () async {
      const ex = NoNetworkException();
      final result = await Future.value(some<CoreException>(ex)).toEitherUnit();
      expect(result, left<CoreException, Unit>(ex));
    });
  });

  group('EitherFutureX', () {
    test('toOptionAsync maps left to some', () async {
      const ex = NoNetworkException();
      final result = await Future.value(
        left<CoreException, int>(ex),
      ).toOptionAsync();
      expect(result, some<CoreException>(ex));
    });

    test('toOptionAsync maps right to none', () async {
      final result = await Future.value(
        right<CoreException, int>(1),
      ).toOptionAsync();
      expect(result, none<CoreException>());
    });
  });

  group('FutureEitherEx', () {
    test('andThenAsync short-circuits on left', () async {
      final first = Future.value(left<String, int>('err'));
      final second = Future.value(right<String, int>(99));
      final result = await first.andThenAsync(second);
      expect(result, left<String, int>('err'));
    });

    test('andThenAsync runs next on right', () async {
      final first = Future.value(right<String, int>(1));
      final second = Future.value(right<String, int>(2));
      final result = await first.andThenAsync(second);
      expect(result, right<String, int>(2));
    });
  });

  group('FutureOptionrEx', () {
    test('andThenAsync short-circuits on some', () async {
      const ex = NoNetworkException();
      final first = Future.value(some<CoreException>(ex));
      final second = Future.value(none<CoreException>());
      final result = await first.andThenAsync(second);
      expect(result, some<CoreException>(ex));
    });

    test('andThenAsync runs next on none', () async {
      final first = Future.value(none<CoreException>());
      final second = Future.value(
        some<CoreException>(const NoNetworkException()),
      );
      final result = await first.andThenAsync(second);
      expect(result, isA<Some<CoreException>>());
    });
  });
}
