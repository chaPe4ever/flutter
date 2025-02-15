import 'package:core/core.dart';

/// Self explained
sealed class CoreEx extends CoreException {
  const CoreEx({
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
  const StorageInitialisationException({
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
  const NoNetworkException({
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
  LaunchUrlException({
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
  UnknownCoreException({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

final class ClientVisibleException extends CoreEx {
  /// Self explained
  const ClientVisibleException({
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
  FirestoreException({
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
  FirestoreNullDocumentSnapshotException({
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
  MaxRefreshTokenRetriesReached({
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
  DioClientException({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

final class UnInitialisedFlavorException extends CoreEx {
  ///
  UnInitialisedFlavorException({
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
  FirestoreFunctionsException({
    super.messageKey = 'unknown_core_exception_message_key',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}
