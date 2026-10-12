import 'package:custom_builders/generators/json_keys_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../helpers/generator_test_helpers.dart';

void main() {
  setUpAll(registerGeneratorTestFallbacks);
  setUp(resetMocktailState);

  final generator = JsonKeysGenerator();

  group('generateForAnnotatedElement', () {
    test('throws when annotation is not on a class', () async {
      final element = MockTopLevelVariableElement();
      when(() => element.name).thenReturn('invalidTarget');
      final buildStep = mockBuildStep(
        package: 'custom_builders',
        inputPath: 'lib/input.dart',
        assets: {},
      );

      await expectLater(
        generator.generateForAnnotatedElement(
          element,
          mockJsonPathReader('assets/missing.json'),
          buildStep,
        ),
        throwsA(
          isA<InvalidGenerationSourceError>().having(
            (error) => error.message,
            'message',
            contains('can only be applied to classes'),
          ),
        ),
      );
    });

    test('throws when JSON asset cannot be read', () async {
      final element = MockClassElement();
      when(() => element.name).thenReturn('MissingJson');
      final buildStep = mockBuildStep(
        package: 'custom_builders',
        inputPath: 'lib/input.dart',
        assets: {},
      );

      await expectLater(
        generator.generateForAnnotatedElement(
          element,
          mockJsonPathReader('test/fixtures/assets/missing.json'),
          buildStep,
        ),
        throwsA(
          isA<InvalidGenerationSourceError>().having(
            (error) => error.message,
            'message',
            contains('File not found for json path'),
          ),
        ),
      );
    });

    test('generates camelCase constants for JSON keys', () async {
      const jsonPath = 'test/fixtures/assets/keys.json';
      final element = MockClassElement();
      when(() => element.name).thenReturn('TransKeys');
      final buildStep = mockBuildStep(
        package: 'custom_builders',
        inputPath: 'lib/input.dart',
        assets: {
          'custom_builders|$jsonPath': await readProjectFile(jsonPath),
        },
      );

      final output = await generator.generateForAnnotatedElement(
        element,
        mockJsonPathReader(jsonPath),
        buildStep,
      );

      expect(
        output,
        '''
class TransKeysKeys {
  static const helloWorld = "hello_world";
  static const fooBar = "foo-bar";
  static const hello = "HELLO";
  static const aB = "a__b";
  static const  = "";
}
''',
      );
    });
  });
}
