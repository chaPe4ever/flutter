import 'package:core/contracts/core_exception.dart';
import 'package:dartz/dartz.dart';

/// Use-case interface which every use-case class should implement
abstract interface class FutureEitherUseCase<T, Param> {
  /// A way to enable the dart callables to the derived classes
  Future<Either<CoreException, T>> call(Param param);
}

/// Use-case interface which every use-case class should implement
abstract interface class FutureOptionUseCase<Param> {
  /// A way to enable the dart callables to the derived classes
  Future<Option<CoreException>> call(Param param);
}

/// Use-case interface which every use-case class should implement
abstract interface class StreamEitherUseCase<T, Param> {
  /// A way to enable the dart callables to the derived classes
  Stream<Either<CoreException, T>> call(Param param);
}

///
abstract interface class FutureEitherNoParamUseCase<T> {
  /// A way to enable the dart callables to the derived classes
  Future<Either<CoreException, T>> call();
}

///
abstract interface class FutureOptionNoParamUseCase {
  /// A way to enable the dart callables to the derived classes
  Future<Option<CoreException>> call();
}

///
abstract interface class StreamEitherNoParamUseCase<T> {
  /// A way to enable the dart callables to the derived classes
  Stream<Either<CoreException, T>> call();
}

///
abstract interface class StreamEitherOptionalParamUseCases<T, Param> {
  /// A way to enable the dart callables to the derived classes
  Stream<Either<CoreException, T>> call([Param param]);
}

///
abstract interface class FutureNoParamUseCase<T> {
  /// A way to enable the dart callables to the derived classes
  Future<T> call();
}

///
abstract interface class FutureParamUseCase<T, Param> {
  /// A way to enable the dart callables to the derived classes
  Future<T> call(Param param);
}

/// Use-case interface which every use-case class should implement
abstract interface class StreamUseCase<T, Param> {
  /// A way to enable the dart callables to the derived classes
  Stream<T> call(Param param);
}

/// Use-case interface which every use-case class should implement
abstract interface class StreamNoParamUseCase<T> {
  /// A way to enable the dart callables to the derived classes
  Stream<T> call();
}
