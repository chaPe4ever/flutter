import 'package:core/core.dart';

abstract class MultiPartFormDataModelBase {
  String get filePath;
  String get fileMapKey;
  final String boundaryName = '--dio-boundary';
  String? filename;
  Map<String, List<String>>? headers;
  ListFormat listFormat = ListFormat.multi;
  bool camelCaseContentDisposition = false;
  DioMediaType? contentType;
}
