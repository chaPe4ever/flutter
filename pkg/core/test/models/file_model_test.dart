import 'package:core/models/file_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileModel', () {
    const model = FileModel(
      fileName: 'doc.pdf',
      base64FileBytes: 'YWJj',
    );

    test('round-trips through json', () {
      final json = model.toJson();
      expect(
        FileModel.fromJson(json),
        model,
      );
    });

    test('copyWith preserves unchanged fields', () {
      expect(
        model.copyWith(fileName: 'other.txt'),
        const FileModel(fileName: 'other.txt', base64FileBytes: 'YWJj'),
      );
    });
  });
}
