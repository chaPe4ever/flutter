import 'package:core/core.dart';

sealed class MultiPartFormDataModel {
  String boundaryName = '--dio-boundary';
  String get filePath;
  String get fileMapKey;
  String? filename;
  Map<String, List<String>>? headers;
  ListFormat listFormat = ListFormat.multi;
  bool camelCaseContentDisposition = false;
  DioMediaType? contentType;
}
