import 'package:core/models/multi_part_form_data_model_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

final class _MinimalMultiPart extends MultiPartFormDataModelBase {
  _MinimalMultiPart({required this.filePath, required this.fileMapKey});

  @override
  final String filePath;

  @override
  final String fileMapKey;
}

final class _TestMultiPart extends MultiPartFormDataModelBase {
  _TestMultiPart({
    required this.filePath,
    required this.fileMapKey,
    this.overrideFilename,
    this.overrideListFormat,
    this.overrideCamelCase,
    this.overrideBoundary,
  }) : overrideHeaders = null;

  @override
  final String filePath;

  @override
  final String fileMapKey;

  final String? overrideFilename;
  final Map<String, List<String>>? overrideHeaders;
  final ListFormat? overrideListFormat;
  final bool? overrideCamelCase;
  final String? overrideBoundary;

  @override
  String? get filename => overrideFilename;

  @override
  Map<String, List<String>>? get headers => overrideHeaders;

  @override
  ListFormat get listFormat => overrideListFormat ?? super.listFormat;

  @override
  bool get camelCaseContentDisposition =>
      overrideCamelCase ?? super.camelCaseContentDisposition;

  @override
  DioMediaType? get contentType => null;

  @override
  String get boundaryName => overrideBoundary ?? super.boundaryName;
}

void main() {
  group('MultiPartFormDataModelBase', () {
    test('base class exposes default optional getters', () {
      final model = _MinimalMultiPart(filePath: '/tmp/a.bin', fileMapKey: 'f');

      expect(model.filename, isNull);
      expect(model.headers, isNull);
      expect(model.contentType, isNull);
    });

    test('exposes default upload metadata', () {
      final model = _TestMultiPart(
        filePath: '/tmp/a.bin',
        fileMapKey: 'file',
      );

      expect(model.boundaryName, '--dio-boundary');
      expect(model.filename, isNull);
      expect(model.headers, isNull);
      expect(model.listFormat, ListFormat.multi);
      expect(model.camelCaseContentDisposition, isFalse);
      expect(model.contentType, isNull);
    });

    test('allows overriding optional fields', () {
      final model = _TestMultiPart(
        filePath: '/tmp/b.bin',
        fileMapKey: 'upload',
        overrideFilename: 'b.bin',
        overrideBoundary: '--custom',
        overrideCamelCase: true,
        overrideListFormat: ListFormat.csv,
      );

      expect(model.filename, 'b.bin');
      expect(model.boundaryName, '--custom');
      expect(model.camelCaseContentDisposition, isTrue);
      expect(model.listFormat, ListFormat.csv);
    });
  });
}
