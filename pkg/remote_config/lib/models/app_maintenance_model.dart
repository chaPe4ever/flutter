import 'dart:convert';

import 'package:core/core.dart';

final class AppMaintenanceModel extends Equatable {
  const new({required this.isActive});

  factory fromMap(Map<String, dynamic> map) {
    return AppMaintenanceModel(isActive: (map['isActive'] ?? false) as bool);
  }

  factory fromJson(String source) =>
      AppMaintenanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory def() => const AppMaintenanceModel(isActive: false);

  final bool isActive;

  @override
  List<Object> get props => [isActive];

  AppMaintenanceModel copyWith({bool? isActive}) {
    return AppMaintenanceModel(isActive: isActive ?? this.isActive);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'isActive': isActive};
  }

  String toJson() => json.encode(toMap());
}
