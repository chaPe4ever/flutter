import 'package:core/core.dart';

base class MultiPartFormDataModel {
  MultiPartFormDataModel({
    required this.filePath,
    required this.fileMapKey,
    this.filename,
    this.headers,
    this.listFormat = ListFormat.multi,
    this.camelCaseContentDisposition = false,
    this.contentType,
    this.boundaryName = '--dio-boundary',
  });

  final String boundaryName;
  final String filePath;
  final String fileMapKey;
  final String? filename;
  final Map<String, List<String>>? headers;
  final ListFormat listFormat;
  final bool camelCaseContentDisposition;
  final DioMediaType? contentType;
}
