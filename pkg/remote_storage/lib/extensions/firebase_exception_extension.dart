import 'package:firebase_storage/firebase_storage.dart';
import 'package:remote_storage/constants/trans_keys_constants.dart';
import 'package:remote_storage/exceptions/exceptions.dart';

///
extension FirebaseExceptionX on FirebaseException {
  ///
  FirebaseRemoteStorageException toFirestoreRemoteStorageEx({
    String messageKey = TransKeys.firebaseRemoteStorageExceptionMessageKey,
  }) =>
      FirebaseRemoteStorageException(
        messageKey: messageKey,
        innerCode: code,
        innerError: this,
        innerMessage: message,
        st: stackTrace,
      );
}
