import 'package:core/core.dart';

abstract class MultiPartFormDataModelBase {
  String get filePath;
  String get fileMapKey;
  String get boundaryName => '--dio-boundary';
  String? get filename;
  Map<String, List<String>>? get headers;
  ListFormat get listFormat => ListFormat.multi;
  bool get camelCaseContentDisposition => false;
  DioMediaType? get contentType;
}
