import 'package:core/core.dart';

/// Value object interface that is used to create valueObject classes
@immutable
abstract base class ValueObject<T> {
  /// Constructor
  const ValueObject();

  /// The value of the valueObject class
  Either<CoreException, T> get value;

  /// Return the data of valueObject class or throw
  T get requireValue => value.fold((l) => throw l, id);

  /// If there is a value it unwraps it, otherwise it returns null
  T? get valueOrNull => value.fold((l) => null, id);

  String? validator(T? value);

  /// Check if the valueObject class has data
  bool isValid() => value.isRight();

  /// Check if the valueObject class has error
  bool isInvalid() => value.isLeft();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value $value';
}
