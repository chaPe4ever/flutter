import 'package:core/core.dart';
import 'package:core/storage/local_storage_impl.dart';

part 'local_storage_pod.g.dart';

/// Local storage pod
@Riverpod(keepAlive: true)
Future<LocalStorageBase> localStorage(Ref ref) {
  return LocalStorageImpl().init();
}
