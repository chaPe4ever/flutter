import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:custom_annotations/custom_annotations.dart';
import 'package:source_gen/source_gen.dart';

class JsonKeysGenerator extends GeneratorForAnnotation<JSONKeysGen> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'Generator cannot target `${element.name}`. `@JSONKeysGen` can only '
        'be applied to classes.',
      );
    }

    final jsonPath = annotation.read('jsonPath').stringValue;
    final assetId = AssetId(buildStep.inputId.package, jsonPath);

    // Check if the file exists
    if (!await buildStep.canRead(assetId)) {
      throw InvalidGenerationSourceError(
        'File not found for json path: $jsonPath',
      );
    }

    final jsonContent = await buildStep.readAsString(assetId);
    final jsonMap = json.decode(jsonContent) as Map<String, dynamic>;

    final buffer = StringBuffer()..writeln('class ${element.name}Keys {');
    jsonMap.forEach((key, value) {
      final formattedKey = _formatKey(key);
      buffer.writeln('  static const $formattedKey = "$key";');
    });
    buffer.writeln('}');

    return buffer.toString();
  }
}

String _formatKey(String key) {
  final words = key.split(RegExp('[_-]')).map((word) {
    return word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '';
  }).toList();

  // Join the words and make the first character lowercase to ensure camelCase
  final camelCase = words.join();
  return camelCase.isNotEmpty
      ? camelCase[0].toLowerCase() + camelCase.substring(1)
      : '';
}
