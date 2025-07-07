// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileModel implements DiagnosticableTreeMixin {

 String get fileName; String get base64FileBytes;
/// Create a copy of FileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileModelCopyWith<FileModel> get copyWith => _$FileModelCopyWithImpl<FileModel>(this as FileModel, _$identity);

  /// Serializes this FileModel to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FileModel'))
    ..add(DiagnosticsProperty('fileName', fileName))..add(DiagnosticsProperty('base64FileBytes', base64FileBytes));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileModel&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.base64FileBytes, base64FileBytes) || other.base64FileBytes == base64FileBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,base64FileBytes);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FileModel(fileName: $fileName, base64FileBytes: $base64FileBytes)';
}


}

/// @nodoc
abstract mixin class $FileModelCopyWith<$Res>  {
  factory $FileModelCopyWith(FileModel value, $Res Function(FileModel) _then) = _$FileModelCopyWithImpl;
@useResult
$Res call({
 String fileName, String base64FileBytes
});




}
/// @nodoc
class _$FileModelCopyWithImpl<$Res>
    implements $FileModelCopyWith<$Res> {
  _$FileModelCopyWithImpl(this._self, this._then);

  final FileModel _self;
  final $Res Function(FileModel) _then;

/// Create a copy of FileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? base64FileBytes = null,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,base64FileBytes: null == base64FileBytes ? _self.base64FileBytes : base64FileBytes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FileModel with DiagnosticableTreeMixin implements FileModel {
  const _FileModel({required this.fileName, required this.base64FileBytes});
  factory _FileModel.fromJson(Map<String, dynamic> json) => _$FileModelFromJson(json);

@override final  String fileName;
@override final  String base64FileBytes;

/// Create a copy of FileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileModelCopyWith<_FileModel> get copyWith => __$FileModelCopyWithImpl<_FileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileModelToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FileModel'))
    ..add(DiagnosticsProperty('fileName', fileName))..add(DiagnosticsProperty('base64FileBytes', base64FileBytes));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileModel&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.base64FileBytes, base64FileBytes) || other.base64FileBytes == base64FileBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,base64FileBytes);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FileModel(fileName: $fileName, base64FileBytes: $base64FileBytes)';
}


}

/// @nodoc
abstract mixin class _$FileModelCopyWith<$Res> implements $FileModelCopyWith<$Res> {
  factory _$FileModelCopyWith(_FileModel value, $Res Function(_FileModel) _then) = __$FileModelCopyWithImpl;
@override @useResult
$Res call({
 String fileName, String base64FileBytes
});




}
/// @nodoc
class __$FileModelCopyWithImpl<$Res>
    implements _$FileModelCopyWith<$Res> {
  __$FileModelCopyWithImpl(this._self, this._then);

  final _FileModel _self;
  final $Res Function(_FileModel) _then;

/// Create a copy of FileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? base64FileBytes = null,}) {
  return _then(_FileModel(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,base64FileBytes: null == base64FileBytes ? _self.base64FileBytes : base64FileBytes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
