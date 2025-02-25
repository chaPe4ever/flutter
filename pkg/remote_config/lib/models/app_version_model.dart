import 'package:core/core.dart';

final class AppVersionModel extends Equatable {
  const AppVersionModel({required this.version, required this.buildNumber});

  AppVersionModel.fromJson(Map<String, dynamic> json)
    : version = json['version'] as String,
      buildNumber = json['build_number'] as int;

  final String version;
  final int buildNumber;

  Map<String, dynamic> toJson() {
    return {'version': version, 'build_number': buildNumber};
  }

  AppVersionModel copyWith({String? version, int? buildNumber}) {
    return AppVersionModel(
      version: version ?? this.version,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }

  @override
  List<Object?> get props => [version, buildNumber];
}

final class AppVersionRemoteModel extends AppVersionModel with EquatableMixin {
  const AppVersionRemoteModel({
    required super.version,
    required super.buildNumber,
    required this.isOptional,
  });

  factory AppVersionRemoteModel.def() {
    return const AppVersionRemoteModel(
      version: '1.0.0',
      buildNumber: 1,
      isOptional: true,
    );
  }

  AppVersionRemoteModel.fromJson(super.json)
    : isOptional = json['is_optional'] as bool,
      super.fromJson();

  final bool isOptional;

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({'is_optional': isOptional});
  }

  @override
  AppVersionRemoteModel copyWith({
    String? version,
    int? buildNumber,
    bool? isOptional,
  }) {
    return AppVersionRemoteModel(
      version: version ?? this.version,
      buildNumber: buildNumber ?? this.buildNumber,
      isOptional: isOptional ?? this.isOptional,
    );
  }

  @override
  List<Object?> get props => [version, buildNumber, isOptional];
}

final class AppVersionUpdateModel extends AppVersionRemoteModel
    with EquatableMixin {
  const AppVersionUpdateModel({
    required super.version,
    required super.buildNumber,
    required super.isOptional,
    required this.isUpdateAvailable,
  });

  factory AppVersionUpdateModel.def() {
    return const AppVersionUpdateModel(
      version: '1.0.0',
      buildNumber: 1,
      isOptional: true,
      isUpdateAvailable: false,
    );
  }

  AppVersionUpdateModel.fromJson(super.json)
    : isUpdateAvailable = json['is_update_available'] as bool,
      super.fromJson();

  final bool isUpdateAvailable;

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({'is_update_available': isUpdateAvailable});
  }

  @override
  AppVersionUpdateModel copyWith({
    String? version,
    int? buildNumber,
    bool? isUpdateAvailable,
    bool? isOptional,
  }) {
    return AppVersionUpdateModel(
      version: version ?? this.version,
      buildNumber: buildNumber ?? this.buildNumber,
      isUpdateAvailable: isUpdateAvailable ?? this.isUpdateAvailable,
      isOptional: isOptional ?? this.isOptional,
    );
  }

  @override
  List<Object?> get props => [
    version,
    buildNumber,
    isOptional,
    isUpdateAvailable,
  ];
}
