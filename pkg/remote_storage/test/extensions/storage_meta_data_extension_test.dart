import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_storage/extensions/storage_meta_data_extension.dart';
import 'package:remote_storage/models/storage_meta_data.dart';

void main() {
  test('toSettableMetaData copies fields onto SettableMetadata', () {
    final metadata = StorageMetadata(
      contentEncoding: 'gzip',
      contentLanguage: 'de',
      contentType: 'text/plain',
      customMetadata: {'tag': 'a'},
    );

    final settable = metadata.toSettableMetaData;

    expect(settable, isA<SettableMetadata>());
    expect(settable.contentEncoding, 'gzip');
    expect(settable.contentLanguage, 'de');
    expect(settable.contentType, 'text/plain');
    expect(settable.customMetadata, {'tag': 'a'});
  });
}
