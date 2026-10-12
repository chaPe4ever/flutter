import 'package:flutter_test/flutter_test.dart';
import 'package:remote_storage/models/storage_meta_data.dart';

void main() {
  group('StorageMetadata.asMap', () {
    test('includes all metadata fields', () {
      final metadata = StorageMetadata(
        contentEncoding: 'gzip',
        contentLanguage: 'en',
        contentType: 'image/png',
        customMetadata: {'owner': 'test'},
      );

      expect(
        metadata.asMap(),
        {
          'contentEncoding': 'gzip',
          'contentLanguage': 'en',
          'contentType': 'image/png',
          'customMetadata': {'owner': 'test'},
        },
      );
    });

    test('preserves null fields in the map', () {
      expect(
        StorageMetadata().asMap(),
        {
          'contentEncoding': null,
          'contentLanguage': null,
          'contentType': null,
          'customMetadata': null,
        },
      );
    });
  });
}
