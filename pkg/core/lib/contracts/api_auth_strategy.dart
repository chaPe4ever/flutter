import 'package:core/core.dart' show CoreException;

abstract interface class ApiAuthStrategy {
  /// Get access token
  ///
  /// Might throw [CoreException]
  Future<String> getAccessToken();
}
