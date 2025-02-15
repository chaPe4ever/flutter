// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FileModel _$FileModelFromJson(Map<String, dynamic> json) {
  return _FileModel.fromJson(json);
}

/// @nodoc
mixin _$FileModel {
  String get fileName => throw _privateConstructorUsedError;
  String get base64FileBytes => throw _privateConstructorUsedError;

  /// Serializes this FileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileModelCopyWith<FileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileModelCopyWith<$Res> {
  factory $FileModelCopyWith(FileModel value, $Res Function(FileModel) then) =
      _$FileModelCopyWithImpl<$Res, FileModel>;
  @useResult
  $Res call({String fileName, String base64FileBytes});
}

/// @nodoc
class _$FileModelCopyWithImpl<$Res, $Val extends FileModel>
    implements $FileModelCopyWith<$Res> {
  _$FileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? base64FileBytes = null,
  }) {
    return _then(_value.copyWith(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      base64FileBytes: null == base64FileBytes
          ? _value.base64FileBytes
          : base64FileBytes // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileModelImplCopyWith<$Res>
    implements $FileModelCopyWith<$Res> {
  factory _$$FileModelImplCopyWith(
          _$FileModelImpl value, $Res Function(_$FileModelImpl) then) =
      __$$FileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fileName, String base64FileBytes});
}

/// @nodoc
class __$$FileModelImplCopyWithImpl<$Res>
    extends _$FileModelCopyWithImpl<$Res, _$FileModelImpl>
    implements _$$FileModelImplCopyWith<$Res> {
  __$$FileModelImplCopyWithImpl(
      _$FileModelImpl _value, $Res Function(_$FileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? base64FileBytes = null,
  }) {
    return _then(_$FileModelImpl(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      base64FileBytes: null == base64FileBytes
          ? _value.base64FileBytes
          : base64FileBytes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileModelImpl with DiagnosticableTreeMixin implements _FileModel {
  const _$FileModelImpl(
      {required this.fileName, required this.base64FileBytes});

  factory _$FileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileModelImplFromJson(json);

  @override
  final String fileName;
  @override
  final String base64FileBytes;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FileModel(fileName: $fileName, base64FileBytes: $base64FileBytes)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FileModel'))
      ..add(DiagnosticsProperty('fileName', fileName))
      ..add(DiagnosticsProperty('base64FileBytes', base64FileBytes));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileModelImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.base64FileBytes, base64FileBytes) ||
                other.base64FileBytes == base64FileBytes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fileName, base64FileBytes);

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileModelImplCopyWith<_$FileModelImpl> get copyWith =>
      __$$FileModelImplCopyWithImpl<_$FileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileModelImplToJson(
      this,
    );
  }
}

abstract class _FileModel implements FileModel {
  const factory _FileModel(
      {required final String fileName,
      required final String base64FileBytes}) = _$FileModelImpl;

  factory _FileModel.fromJson(Map<String, dynamic> json) =
      _$FileModelImpl.fromJson;

  @override
  String get fileName;
  @override
  String get base64FileBytes;

  /// Create a copy of FileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileModelImplCopyWith<_$FileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
