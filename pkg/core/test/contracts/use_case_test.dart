import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FutureEitherUseCase implements FutureEitherUseCase<String, int> {
  @override
  Future<Either<CoreException, String>> call(int param) async =>
      right('value-$param');
}

final class _FutureOptionUseCase implements FutureOptionUseCase<int> {
  @override
  Future<Option<CoreException>> call(int param) async => none();
}

final class _StreamEitherUseCase implements StreamEitherUseCase<String, int> {
  @override
  Stream<Either<CoreException, String>> call(int param) =>
      Stream.value(right('stream-$param'));
}

final class _FutureEitherNoParamUseCase
    implements FutureEitherNoParamUseCase<String> {
  @override
  Future<Either<CoreException, String>> call() async => right('ok');
}

final class _FutureOptionNoParamUseCase implements FutureOptionNoParamUseCase {
  @override
  Future<Option<CoreException>> call() async => some(UnknownCoreException());
}

final class _StreamEitherNoParamUseCase
    implements StreamEitherNoParamUseCase<int> {
  @override
  Stream<Either<CoreException, int>> call() => Stream.value(right(42));
}

final class _StreamEitherOptionalParamUseCases
    implements StreamEitherOptionalParamUseCases<String, String> {
  @override
  Stream<Either<CoreException, String>> call([String? param]) =>
      Stream.value(right(param ?? 'default'));
}

final class _FutureNoParamUseCase implements FutureNoParamUseCase<int> {
  @override
  Future<int> call() async => 7;
}

final class _FutureParamUseCase implements FutureParamUseCase<String, bool> {
  @override
  Future<String> call(bool param) async => param.toString();
}

final class _StreamUseCase implements StreamUseCase<int, String> {
  @override
  Stream<int> call(String param) => Stream.value(param.length);
}

final class _StreamNoParamUseCase implements StreamNoParamUseCase<String> {
  @override
  Stream<String> call() => Stream.value('ping');
}

void main() {
  group('use case callables', () {
    test('FutureEitherUseCase', () async {
      final result = await _FutureEitherUseCase().call(3);
      expect(result, right<CoreException, String>('value-3'));
    });

    test('FutureOptionUseCase', () async {
      final result = await _FutureOptionUseCase().call(1);
      expect(result.isNone(), isTrue);
    });

    test('StreamEitherUseCase', () async {
      final result = await _StreamEitherUseCase().call(2).first;
      expect(result, right<CoreException, String>('stream-2'));
    });

    test('FutureEitherNoParamUseCase', () async {
      final result = await _FutureEitherNoParamUseCase().call();
      expect(result, right<CoreException, String>('ok'));
    });

    test('FutureOptionNoParamUseCase', () async {
      final result = await _FutureOptionNoParamUseCase().call();
      expect(result.isSome(), isTrue);
    });

    test('StreamEitherNoParamUseCase', () async {
      final result = await _StreamEitherNoParamUseCase().call().first;
      expect(result, right<CoreException, int>(42));
    });

    test('StreamEitherOptionalParamUseCases with param', () async {
      final result = await _StreamEitherOptionalParamUseCases().call('x').first;
      expect(result, right<CoreException, String>('x'));
    });

    test('StreamEitherOptionalParamUseCases without param', () async {
      final result = await _StreamEitherOptionalParamUseCases().call().first;
      expect(result, right<CoreException, String>('default'));
    });

    test('FutureNoParamUseCase', () async {
      expect(await _FutureNoParamUseCase().call(), 7);
    });

    test('FutureParamUseCase', () async {
      expect(await _FutureParamUseCase().call(true), 'true');
    });

    test('StreamUseCase', () async {
      expect(await _StreamUseCase().call('abcd').first, 4);
    });

    test('StreamNoParamUseCase', () async {
      expect(await _StreamNoParamUseCase().call().first, 'ping');
    });
  });
}
