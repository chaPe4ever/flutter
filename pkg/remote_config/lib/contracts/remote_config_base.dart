import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:remote_config/models/app_maintenance_model.dart';
import 'package:remote_config/models/app_version_model.dart';

///
abstract interface class RemoteConfigBase {
  /// Might throw [CoreException]
  Future<Either<CoreException, AppVersionUpdateModel>> getAppUpdateStatus();

  /// Might throw [CoreException]
  Future<void> init({
    required NetworkBase network,
    Duration fetchTimeout = const Duration(minutes: 1),
    Duration minimumFetchInterval = kDebugMode
        ? Duration.zero
        : const Duration(hours: 1),
  });

  /// Stream controller to listen to remote config key changes
  Stream<Set<String>> get configUpdatesStream;

  /// It force fetches and activates any updates from remote config
  ///
  /// Might throw [CoreException]
  Future<void> fetchAndActivate();

  /// Dispose the remote config when there is no usage
  void dispose();

  ///
  bool get isFetchSucceeded;

  /// Activated value for [key].
  ///
  /// [fallback] applies only when the key has no in-app default and no
  /// fetched value. A fetched empty string is returned as-is.
  String getString(String key, {String? fallback});

  /// Activated value for [key].
  ///
  /// [fallback] applies only when the key has no in-app default and no
  /// fetched value. A fetched `0` is returned as-is.
  int getInt(String key, {int? fallback});

  /// Activated value for [key].
  ///
  /// [fallback] applies only when the key has no in-app default and no
  /// fetched value. A fetched `false` is returned as-is.
  bool getBool(String key, {bool? fallback});

  /// Listens for remote config updates
  ///
  /// Might throw [CoreException]
  void addListener({
    void Function(Either<CoreException, AppVersionUpdateModel>)?
    onVersionUpdate,
    void Function(Either<CoreException, AppMaintenanceModel>)?
    onMaintenanceUpdate,
  });

  void removeListener({
    void Function(Either<CoreException, AppVersionUpdateModel>)?
    onVersionUpdate,
    void Function(Either<CoreException, AppMaintenanceModel>)?
    onMaintenanceUpdate,
  });

  /// Might throw [CoreException]
  Future<Either<CoreException, AppMaintenanceModel>> getAppMaintenanceStatus();
}
