import 'package:core/core.dart';

sealed class SharedUiEx extends CoreException {
  const SharedUiEx({
    required super.messageKey,
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
    super.prefix = 'shared_ui',
  });
}

final class NoteException extends SharedUiEx {
  const NoteException({
    // TODO: Add message key
    super.messageKey = 'hardcoded',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

final class PageNotFoundCoreException extends SharedUiEx {
  const PageNotFoundCoreException({
    // TODO: Add message key
    super.messageKey = 'hardcoded',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

final class UnknownSharedUiException extends SharedUiEx {
  const UnknownSharedUiException({
    // TODO: Add message key
    super.messageKey = 'hardcoded',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}
