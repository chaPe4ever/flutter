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
    Duration minimumFetchInterval =
        kDebugMode ? Duration.zero : const Duration(hours: 1),
  });

  /// Stream controller to listen to remote config key changes
  StreamController<Set<String>> get remoteConfigUpdatesController;

  /// It force fetches and activates any updates from remote config
  ///
  /// Might throw [CoreException]
  Future<void> fetchAndActivate();

  /// Dispose the remote config when there is no usage
  void dispose();

  ///
  bool get isFetchSucceeded;

  /// Listens for remote config updates
  ///
  /// Might throw [CoreException]
  void configUpdatesListener({
    void Function(Either<CoreException, AppVersionUpdateModel> cb)?
    onVersionUpdate,
    void Function(Either<CoreException, AppMaintenanceModel> cb)?
    onMaintenanceUpdate,
  });

  /// Might throw [CoreException]
  Future<Either<CoreException, AppMaintenanceModel>> getAppMaintenanceStatus();
}
