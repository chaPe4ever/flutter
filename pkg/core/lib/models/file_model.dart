import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_model.g.dart';

part 'file_model.freezed.dart';

@freezed
class FileModel with _$FileModel {
  const factory FileModel({
    required String fileName,
    required String base64FileBytes,
  }) = _FileModel;

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);
}
