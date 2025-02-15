import 'package:core/core.dart';

/// A class that extends the Either class from the dartz package.
extension EitherX<T> on Either<CoreException, T> {
  /// Returns the right value or throws an exception if it is left.
  T getOrCrash() => fold((l) => throw l, id);

  /// Returns the cb value of the [ifRight] arg or throws an exception if it is
  ///  left.
  B getOrThrow<B>(B Function(T r) ifRight) => fold((l) => throw l, ifRight);
}

extension OptionX on Future<Option<CoreException>> {
  Future<Either<CoreException, Unit>> toEitherUnit() =>
      then((option) async => option.toEither(() => unit).swap());
}

extension EitherFutureX<T> on Future<Either<CoreException, T>> {
  Future<Option<CoreException>> toOptionAsync() =>
      then((either) async => either.swap().toOption());
}

extension FutureEitherEx<L, R> on Future<Either<L, R>> {
  Future<Either<L, R>> andThenAsync(Future<Either<L, R>> next) async {
    if ((await this).isLeft()) return this;
    return next;
  }
}

extension FutureOptionrEx<L, R> on Future<Option<L>> {
  Future<Option<L>> andThenAsync(Future<Option<L>> next) async {
    if ((await this).isSome()) return this;
    return next;
  }
}
