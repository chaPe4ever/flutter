// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileModelImpl _$$FileModelImplFromJson(Map<String, dynamic> json) =>
    _$FileModelImpl(
      fileName: json['fileName'] as String,
      base64FileBytes: json['base64FileBytes'] as String,
    );

Map<String, dynamic> _$$FileModelImplToJson(_$FileModelImpl instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'base64FileBytes': instance.base64FileBytes,
    };
