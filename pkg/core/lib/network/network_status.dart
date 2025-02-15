/// Network status enum
enum NetworkStatus {
  /// For wifi connection
  wifi,

  /// For internet data connection,
  cellular,

  /// When there is no connection
  offline,

  ///any other state that the device might has which is not included in the
  /// previous categories
  other,
}
