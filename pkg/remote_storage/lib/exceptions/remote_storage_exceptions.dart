import 'package:core/core.dart';
import 'package:remote_storage/constants/remote_storage_constants.dart';

///
sealed class RemoteStorageEx extends CoreException {
  const RemoteStorageEx({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix = kRemoteStoragePkgName,
  });
}

///
final class FirebaseRemoteStorageException extends RemoteStorageEx {
  ///
  FirebaseRemoteStorageException({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}
