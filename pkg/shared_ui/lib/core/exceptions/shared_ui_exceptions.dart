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
    // TODOAdd message key
    super.messageKey = 'hardcoded',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

final class PageNotFoundCoreException extends SharedUiEx {
  const PageNotFoundCoreException({
    // TODOAdd message key
    super.messageKey = 'hardcoded',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}

final class UnknownSharedUiException extends SharedUiEx {
  const UnknownSharedUiException({
    // TODOAdd message key
    super.messageKey = 'hardcoded',
    super.innerCode,
    super.innerMessage,
    super.innerError,
    super.st,
  });
}
