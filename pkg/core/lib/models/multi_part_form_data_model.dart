import 'package:core/core.dart';

base class MultiPartFormDataModel {
  String boundaryName = '--dio-boundary';
  String get filePath => throw UnimplementedError();
  String get fileMapKey => throw UnimplementedError();
  String? filename;
  Map<String, List<String>>? headers;
  ListFormat listFormat = ListFormat.multi;
  bool camelCaseContentDisposition = false;
  DioMediaType? contentType;
}
