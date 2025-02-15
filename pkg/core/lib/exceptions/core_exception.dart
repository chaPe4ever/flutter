/// [CoreException] is the default exception for all the projects and is used
/// so that we don't have dependencies from 3rd party pkgs
abstract base class CoreException implements Exception {
  /// Constructor
  const CoreException({
    required this.messageKey,
    this.prefix,
    this.innerError,
    this.innerCode,
    this.innerMessage,
    this.st,
  });

  /// [messageKey] is a parameter that we use in order to show to user the cause
  /// of this error
  final String messageKey;

  /// [prefix] can be used if we need to have additional information for the
  /// error that we may not want to include into [messageKey]
  final String? prefix;

  /// As an [innerError] we can pass the real raw/inner error we normally get
  /// from a catch block
  final dynamic innerError;

  /// We can save the [innerCode] we might get normally from a 3rd party pkg
  final String? innerCode;

  /// We can save the [innerMessage] we might get normally from a 3rd party pkg
  final String? innerMessage;

  /// [st] is used when we want to save the current [StackTrace]
  final StackTrace? st;

  @override
  String toString() {
    return '${prefix == null ? '' : '$prefix : '}$messageKey';
  }
}
