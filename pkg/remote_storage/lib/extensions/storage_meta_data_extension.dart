import 'package:firebase_storage/firebase_storage.dart';
import 'package:remote_storage/models/models.dart';

///
extension StorageMetaDataX on StorageMetadata {
  ///
  SettableMetadata get toSettableMetaData => SettableMetadata(
    contentEncoding: contentEncoding,
    contentLanguage: contentLanguage,
    contentType: contentType,
    customMetadata: customMetadata,
  );
}
