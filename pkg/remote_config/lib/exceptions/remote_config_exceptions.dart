import 'package:core/core.dart';
import 'package:remote_config/constants/remote_config_constants.dart';
import 'package:remote_config/constants/trans_keys_constants.dart';

///
sealed class RemoteConfigEx extends CoreException {
  const RemoteConfigEx({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix = kRemoteConfigPkgName,
  });
}

/// UnknownCrashlyticsException is used as a fallback exception
final class RemoteConfigFirebaseException extends RemoteConfigEx {
  ///
  const RemoteConfigFirebaseException({
    super.messageKey = TransKeys.remoteConfigFirebaseExceptionMessageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}
