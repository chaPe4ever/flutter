import 'package:custom_annotations/custom_annotations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('barrel export exposes JSONKeysGen and jsonTransKeysGen', () {
    const annotation = JSONKeysGen(jsonPath: 'via/barrel.json');

    expect(annotation, isA<JSONKeysGen>());
    expect(annotation.jsonPath, 'via/barrel.json');
    expect(jsonTransKeysGen.jsonPath, isNotEmpty);
  });
}
