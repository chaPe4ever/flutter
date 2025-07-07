// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileModel _$FileModelFromJson(Map<String, dynamic> json) => _FileModel(
  fileName: json['fileName'] as String,
  base64FileBytes: json['base64FileBytes'] as String,
);

Map<String, dynamic> _$FileModelToJson(_FileModel instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'base64FileBytes': instance.base64FileBytes,
    };
