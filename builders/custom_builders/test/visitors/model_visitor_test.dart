import 'package:custom_builders/visitors/model_visitor.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../helpers/generator_test_helpers.dart';

void main() {
  setUpAll(registerGeneratorTestFallbacks);
  setUp(resetMocktailState);

  test('ModelVisitor captures constructor return type and fields', () {
    final constructor = MockConstructorElement();
    final nameField = MockFieldElement();
    final countField = MockFieldElement();

    final returnType = fakeReturnType('MyModel*');
    when(() => constructor.returnType).thenReturn(returnType);
    final nameType = fakeReturnType('String*');
    final countType = fakeReturnType('int*');
    when(() => nameField.displayName).thenReturn('name');
    when(() => nameField.type).thenReturn(nameType);
    when(() => countField.displayName).thenReturn('count');
    when(() => countField.type).thenReturn(countType);

    final visitor = ModelVisitor()
      ..visitConstructorElement(constructor)
      ..visitFieldElement(nameField)
      ..visitFieldElement(countField);

    expect(visitor.className, 'MyModel');
    expect(
      visitor.fields,
      {
        'name': 'String',
        'count': 'int',
      },
    );
  });

  test('ModelVisitor keeps nullable types without star suffix', () {
    final constructor = MockConstructorElement();
    final labelField = MockFieldElement();

    final returnType = fakeReturnType('NullableModel*');
    when(() => constructor.returnType).thenReturn(returnType);
    final labelType = fakeReturnType('String?');
    when(() => labelField.displayName).thenReturn('label');
    when(() => labelField.type).thenReturn(labelType);

    final visitor = ModelVisitor()
      ..visitConstructorElement(constructor)
      ..visitFieldElement(labelField);

    expect(visitor.className, 'NullableModel');
    expect(visitor.fields['label'], 'String?');
  });
}
