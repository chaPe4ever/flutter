import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListX', () {
    test('sorted returns a new sorted list', () {
      expect([3, 1, 2].sorted((a, b) => a.compareTo(b)), [1, 2, 3]);
    });
  });

  group('StringX', () {
    test('append and prepend and suffix', () {
      expect('path'.append('tail'), 'pathtail');
      expect('child'.prepend('parent'), 'parent/child');
      expect('a'.suffix('b'), 'a/b');
      expect('a'.suffix('b', slashSeperated: false), 'ab');
    });

    test('toSnakeCase', () {
      expect('FooBar'.toSnakeCase(), 'foo_bar');
      expect('FooBar'.toSnakeCase(asLowerCase: false), 'Foo_Bar');
    });

    test('capitalize', () {
      expect('hello'.capitalize(), 'Hello');
      expect(''.capitalize(), '');
    });

    test('toUniqueId', () {
      expect('abc'.toUniqueId().value.getOrCrash(), 'abc');
    });
  });

  group('IntX', () {
    test('isOk', () {
      expect(200.isOk, isTrue);
      expect(299.isOk, isTrue);
      expect(199.isOk, isFalse);
      expect(300.isOk, isFalse);
    });

    test('append', () {
      expect(42.append('px'), '42px');
    });

    test('hardcoded returns self', () {
      expect(42.hardcoded, 42);
    });
  });

  group('hardcoded getters', () {
    test('StringX hardcoded returns self', () {
      expect('value'.hardcoded, 'value');
    });

    test('num and double hardcoded return self', () {
      const num whole = 2;
      expect(whole.hardcoded, 2);
      expect(1.5.hardcoded, 1.5);
      expect(2.hardcoded, 2);
    });

    test('bool hardcoded returns self', () {
      expect(true.hardcoded, isTrue);
    });
  });

  group('ObjectX', () {
    test('returns CoreException as-is', () {
      const ex = NoNetworkException();
      expect(ex.toCoreException(), same(ex));
    });

    test('wraps unknown errors', () {
      final wrapped = Object().toCoreException();
      expect(wrapped, isA<UnknownCoreException>());
    });

    test('uses customEx when provided', () {
      const custom = NoNetworkException();
      expect('x'.toCoreException(customEx: custom), same(custom));
    });
  });

  group('ValueNotifierX', () {
    test('toggle flips bool value', () {
      final notifier = ValueNotifier<bool>(false)..toggle();
      expect(notifier.value, isTrue);
      notifier.toggle();
      expect(notifier.value, isFalse);
    });
  });
}
