import 'package:core/core.dart';

/// [UniqueId] value object
final class UniqueId extends ValueObject<String> {
  /// We cannot let a simple String be passed in. This would allow for
  /// possible non-unique IDs.
  factory UniqueId() => UniqueId._(
        right(const Uuid().v1()),
      );

  const UniqueId._(this.value);

  /// Used with strings we trust are unique, such as database IDs.
  factory UniqueId.fromUniqueString(String uniqueIdStr) {
    return UniqueId._(
      right(uniqueIdStr),
    );
  }

  @override
  String? validator(String? value) {
    return UniqueId._(validateId(value)).value.fold(
          (l) => l.messageKey,
          (r) => null,
        );
  }

  @override
  final Either<CoreException, String> value;
}

Either<CoreException, String> validateId(String? input) {
  if (input == null || input.isEmpty) {
    return left(UnknownCoreException(messageKey: 'id_cannot_be_empty'));
  }
  return right(input);
}
