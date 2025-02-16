import 'package:core/core.dart';

abstract class MultiPartFormDataModelBase {
  String get filePath;
  String get fileMapKey;
  String get boundaryName => '--dio-boundary';
  String? get filename => null;
  Map<String, List<String>>? get headers => null;
  ListFormat get listFormat => ListFormat.multi;
  bool get camelCaseContentDisposition => false;
  DioMediaType? get contentType => null;
}
