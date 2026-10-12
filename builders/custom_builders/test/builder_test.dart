import 'package:build/build.dart';
import 'package:custom_builders/builder.dart';
import 'package:custom_builders/generators/json_keys_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'helpers/generator_test_helpers.dart';

void main() {
  setUpAll(registerGeneratorTestFallbacks);
  setUp(resetMocktailState);

  test('jsonKeysGenerator returns a Builder', () {
    final builder = jsonKeysGenerator(BuilderOptions.empty);

    expect(builder, isA<Builder>());
    expect(
      builder.buildExtensions,
      containsPair('.dart', ['.json_keys_gen.g.part']),
    );
  });

  test('jsonKeysGenerator delegates to JsonKeysGenerator', () async {
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

    final output = await JsonKeysGenerator().generateForAnnotatedElement(
      element,
      mockJsonPathReader(jsonPath),
      buildStep,
    );

    expect(
      output,
      allOf(
        contains('class TransKeysKeys'),
        contains('static const helloWorld = "hello_world"'),
        contains('static const fooBar = "foo-bar"'),
      ),
    );
  });
}
