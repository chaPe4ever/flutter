import 'package:core/contracts/core_exception.dart';
import 'package:dartz/dartz.dart';

/// Use-case interface which every use-case class should implement
abstract interface class FutureEitherUseCase<Type, Param> {
  /// A way to enable the dart callables to the derived classes
  Future<Either<CoreException, Type>> call(Param param);
}

/// Use-case interface which every use-case class should implement
abstract interface class FutureOptionUseCase<Param> {
  /// A way to enable the dart callables to the derived classes
  Future<Option<CoreException>> call(Param param);
}

/// Use-case interface which every use-case class should implement
abstract interface class StreamEitherUseCase<Type, Param> {
  /// A way to enable the dart callables to the derived classes
  Stream<Either<CoreException, Type>> call(Param param);
}

///
abstract interface class FutureEitherNoParamUseCase<Type> {
  /// A way to enable the dart callables to the derived classes
  Future<Either<CoreException, Type>> call();
}

///
abstract interface class FutureOptionNoParamUseCase {
  /// A way to enable the dart callables to the derived classes
  Future<Option<CoreException>> call();
}

///
abstract interface class StreamEitherNoParamUseCase<Type> {
  /// A way to enable the dart callables to the derived classes
  Stream<Either<CoreException, Type>> call();
}

///
abstract interface class StreamEitherOptionalParamUseCases<Type, Param> {
  /// A way to enable the dart callables to the derived classes
  Stream<Either<CoreException, Type>> call([Param param]);
}

///
abstract interface class FutureNoParamUseCase<Type> {
  /// A way to enable the dart callables to the derived classes
  Future<Type> call();
}

///
abstract interface class FutureParamUseCase<Type, Param> {
  /// A way to enable the dart callables to the derived classes
  Future<Type> call(Param param);
}

/// Use-case interface which every use-case class should implement
abstract interface class StreamUseCase<Type, Param> {
  /// A way to enable the dart callables to the derived classes
  Stream<Type> call(Param param);
}

/// Use-case interface which every use-case class should implement
abstract interface class StreamNoParamUseCase<Type> {
  /// A way to enable the dart callables to the derived classes
  Stream<Type> call();
}
