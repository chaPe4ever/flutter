// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:core/core.dart';

final class AppMaintenanceModel extends Equatable {
  const AppMaintenanceModel({required this.isActive});

  final bool isActive;

  @override
  List<Object> get props => [isActive];

  AppMaintenanceModel copyWith({bool? isActive}) {
    return AppMaintenanceModel(isActive: isActive ?? this.isActive);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'isActive': isActive};
  }

  factory AppMaintenanceModel.fromMap(Map<String, dynamic> map) {
    return AppMaintenanceModel(isActive: (map['isActive'] ?? false) as bool);
  }

  String toJson() => json.encode(toMap());

  factory AppMaintenanceModel.fromJson(String source) =>
      AppMaintenanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory AppMaintenanceModel.def() =>
      const AppMaintenanceModel(isActive: false);
}
