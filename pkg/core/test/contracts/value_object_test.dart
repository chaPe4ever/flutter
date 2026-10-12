import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

final class _StringValue extends ValueObject<String> {
  const _StringValue(this.value);

  @override
  final Either<CoreException, String> value;

  @override
  String? validator(String? input) => null;
}

void main() {
  group('ValueObject', () {
    test('requireValue returns the right side', () {
      final vo = _StringValue(right('hello'));
      expect(vo.requireValue, 'hello');
    });

    test('requireValue throws the left exception', () {
      final error = UnknownCoreException(messageKey: 'bad');
      final vo = _StringValue(left(error));
      expect(() => vo.requireValue, throwsA(same(error)));
    });

    test('valueOrNull unwraps or returns null', () {
      expect(_StringValue(right('x')).valueOrNull, 'x');
      expect(
        _StringValue(left(UnknownCoreException())).valueOrNull,
        isNull,
      );
    });

    test('isValid and isInvalid reflect Either state', () {
      expect(_StringValue(right('x')).isValid(), isTrue);
      expect(_StringValue(right('x')).isInvalid(), isFalse);
      expect(_StringValue(left(UnknownCoreException())).isValid(), isFalse);
      expect(_StringValue(left(UnknownCoreException())).isInvalid(), isTrue);
    });

    test('equality and hashCode use value', () {
      final a = _StringValue(right('same'));
      final b = _StringValue(right('same'));
      final c = _StringValue(right('other'));

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
    });

    test('toString includes the Either value', () {
      expect(
        _StringValue(right('data')).toString(),
        'Value ${right<CoreException, String>('data')}',
      );
    });
  });
}
