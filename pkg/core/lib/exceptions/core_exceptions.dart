import 'package:core/core.dart';

/// Self explained
sealed class CoreEx extends CoreException {
  const new({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix = kCorePkgName,
  });
}

/// Self explained
final class StorageInitialisationException extends CoreEx {
  /// Self explained
  const new({
    super.messageKey = 'storage_initialisation_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

/// Self explained
final class NoNetworkException extends CoreEx {
  /// Self explained
  const new({
    super.messageKey = 'no_network_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

/// Self explained
final class LaunchUrlException extends CoreEx {
  /// Self explained
  new({
    super.messageKey = 'launch_url_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

/// Self explained
final class UnknownCoreException extends CoreEx {
  /// Self explained
  new({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class ClientVisibleException extends CoreEx {
  /// Self explained
  const new({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

///
final class FirestoreException extends CoreEx {
  ///
  new({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

///
final class FirestoreNullDocumentSnapshotException extends CoreEx {
  ///
  new({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

///
final class MaxRefreshTokenRetriesReached extends CoreEx {
  ///
  new({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

///
final class DioClientException extends CoreEx {
  ///
  new({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

final class UnInitialisedFlavorException extends CoreEx {
  ///
  new({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

///
final class FirestoreFunctionsException extends CoreEx {
  ///
  new({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}
