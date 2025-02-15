import 'package:core/core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:remote_storage/contracts/contracts.dart';
import 'package:remote_storage/implementations/firebase_storage_impl.dart';

part 'remote_storage_pod.g.dart';

///
@Riverpod(keepAlive: true)
RemoteStorageBase remoteStorage(Ref ref) =>
    FirebaseRemoteStorageImpl(firebaseStorage: FirebaseStorage.instance);
