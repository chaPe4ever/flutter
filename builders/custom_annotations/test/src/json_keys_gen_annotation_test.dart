import 'package:custom_annotations/src/json_keys_gen_annotation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JSONKeysGen', () {
    test('exposes jsonPath from constructor', () {
      const annotation = JSONKeysGen(jsonPath: 'assets/custom.json');

      expect(annotation.jsonPath, 'assets/custom.json');
    });

    test('supports const construction', () {
      const first = JSONKeysGen(jsonPath: 'same/path.json');
      const second = JSONKeysGen(jsonPath: 'same/path.json');

      expect(first.jsonPath, second.jsonPath);
    });
  });

  group('jsonTransKeysGen', () {
    test('is a JSONKeysGen with the default translation path', () {
      expect(jsonTransKeysGen, isA<JSONKeysGen>());
      expect(jsonTransKeysGen.jsonPath, 'assets/translations/en.json');
    });
  });
}
