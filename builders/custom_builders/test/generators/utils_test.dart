import 'package:custom_builders/generators/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../helpers/generator_test_helpers.dart';

void main() {
  setUpAll(registerGeneratorTestFallbacks);
  setUp(resetMocktailState);

  test('topLevelNumVariables returns int, double, and num variables', () {
    final reader = MockLibraryReader();
    final intVariable = MockTopLevelVariableElement();
    final doubleVariable = MockTopLevelVariableElement();
    final numVariable = MockTopLevelVariableElement();
    final stringVariable = MockTopLevelVariableElement();

    final intType = mockCoreType(isInt: true);
    final doubleType = mockCoreType(isDouble: true);
    final numType = mockCoreType(isNum: true);
    final stringType = mockCoreType();

    when(() => intVariable.type).thenReturn(intType);
    when(() => doubleVariable.type).thenReturn(doubleType);
    when(() => numVariable.type).thenReturn(numType);
    when(() => stringVariable.type).thenReturn(stringType);

    when(() => intVariable.name).thenReturn('topLevelInt');
    when(() => doubleVariable.name).thenReturn('topLevelDouble');
    when(() => numVariable.name).thenReturn('topLevelNum');
    when(() => stringVariable.name).thenReturn('topLevelString');

    when(() => reader.allElements).thenReturn([
      intVariable,
      doubleVariable,
      numVariable,
      stringVariable,
    ]);

    final names = topLevelNumVariables(reader).map((e) => e.name).toList();

    expect(
      names,
      ['topLevelInt', 'topLevelDouble', 'topLevelNum'],
    );
  });

  test('topLevelNumVariables ignores non-num top-level variables', () {
    final reader = MockLibraryReader();
    final intVariable = MockTopLevelVariableElement();
    final intType = mockCoreType(isInt: true);

    when(() => intVariable.type).thenReturn(intType);
    when(() => intVariable.name).thenReturn('onlyInt');
    when(() => reader.allElements).thenReturn([intVariable]);

    final names = topLevelNumVariables(reader).map((e) => e.name).toList();

    expect(names, ['onlyInt']);
  });
}
