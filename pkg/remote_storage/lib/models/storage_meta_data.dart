/// [StorageMetadata] class used to set and get metadata from server
final class StorageMetadata {
  /// Creates a new [StorageMetadata] instance.
  StorageMetadata({
    this.contentEncoding,
    this.contentLanguage,
    this.contentType,
    this.customMetadata,
  });

  /// Served as the 'Content-Encoding' header on object download.
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Encoding.
  final String? contentEncoding;

  /// Served as the 'Content-Language' header on object download.
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Language.
  final String? contentLanguage;

  /// Served as the 'Content-Type' header on object download.
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type.
  final String? contentType;

  /// Additional user-defined custom metadata.
  final Map<String, String>? customMetadata;

  /// Returns the settable metadata as a [Map].
  Map<String, dynamic> asMap() {
    return <String, dynamic>{
      'contentEncoding': contentEncoding,
      'contentLanguage': contentLanguage,
      'contentType': contentType,
      'customMetadata': customMetadata,
    };
  }
}
