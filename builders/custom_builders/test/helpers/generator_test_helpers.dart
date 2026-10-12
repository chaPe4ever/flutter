import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:custom_annotations/custom_annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_gen/source_gen.dart';

class MockBuildStep extends Mock implements BuildStep {}

class MockClassElement extends Mock implements ClassElement {}

class MockTopLevelVariableElement extends Mock
    implements TopLevelVariableElement {}

class MockConstantReader extends Mock implements ConstantReader {}

class MockLibraryReader extends Mock implements LibraryReader {}

class MockDartType extends Mock implements DartType {}

class FakeReturnType extends Fake implements InterfaceType {
  FakeReturnType(this.typeName);

  final String typeName;

  @override
  String toString() => typeName;
}

class MockConstructorElement extends Mock implements ConstructorElement {}

class MockFieldElement extends Mock implements FieldElement {}

void registerGeneratorTestFallbacks() {
  registerFallbackValue(AssetId('fallback', 'fallback'));
  registerFallbackValue(
    const TypeChecker.typeNamed(JSONKeysGen, inPackage: 'custom_annotations'),
  );
}

MockBuildStep mockBuildStep({
  required String package,
  required String inputPath,
  required Map<String, String> assets,
}) {
  final buildStep = MockBuildStep();
  when(() => buildStep.inputId).thenReturn(AssetId(package, inputPath));

  when(() => buildStep.canRead(any())).thenAnswer((invocation) async {
    final id = invocation.positionalArguments.first as AssetId;
    return assets.containsKey('${id.package}|${id.path}');
  });

  when(() => buildStep.readAsString(any())).thenAnswer((invocation) async {
    final id = invocation.positionalArguments.first as AssetId;
    final key = '${id.package}|${id.path}';
    final content = assets[key];
    if (content == null) {
      throw StateError('Asset not found: $key');
    }
    return content;
  });

  return buildStep;
}

MockConstantReader mockJsonPathReader(String jsonPath) {
  final root = MockConstantReader();
  final jsonPathReader = MockConstantReader();
  when(() => root.read('jsonPath')).thenReturn(jsonPathReader);
  when(() => jsonPathReader.stringValue).thenReturn(jsonPath);
  return root;
}

Future<String> readProjectFile(String relativePath) {
  return File(relativePath).readAsString();
}

MockDartType mockCoreType({
  bool isInt = false,
  bool isDouble = false,
  bool isNum = false,
}) {
  final type = MockDartType();
  when(() => type.isDartCoreInt).thenReturn(isInt);
  when(() => type.isDartCoreDouble).thenReturn(isDouble);
  when(() => type.isDartCoreNum).thenReturn(isNum);
  return type;
}

FakeReturnType fakeReturnType(String typeName) => FakeReturnType(typeName);
