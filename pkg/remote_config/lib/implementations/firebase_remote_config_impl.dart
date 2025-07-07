import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:remote_config/contracts/contracts.dart';
import 'package:remote_config/exceptions/exceptions.dart';
import 'package:remote_config/extensions/app_version_extensions.dart';
import 'package:remote_config/helpers/app_version_helper.dart';
import 'package:remote_config/models/app_maintenance_model.dart';
import 'package:remote_config/models/app_version_model.dart';

///
final class FirebaseRemoteConfigImpl implements RemoteConfigBase {
  /// Constructor
  FirebaseRemoteConfigImpl({required FirebaseRemoteConfig firebaseRemoteConfig})
    : _firebaseRemoteConfig = firebaseRemoteConfig,
      _remoteConfigKeysSetController =
          StreamController<Set<String>>.broadcast() {
    _subscription = _firebaseRemoteConfig.onConfigUpdated.listen(
      (RemoteConfigUpdate result) {
        _remoteConfigKeysSetController.add(result.updatedKeys);
      },
      onError: (dynamic e, StackTrace st) {
        //! Open bug
        //https://github.com/firebase/flutterfire/issues/10780
        if (e is PlatformException) {
          Log.error(
            e.message ?? e.details.toString(),
            st: e.stacktrace != null
                ? StackTrace.fromString(e.stacktrace!)
                : st,
          );
        }
      },
    );
  }

  // Fields
  final FirebaseRemoteConfig _firebaseRemoteConfig;
  late final StreamSubscription<RemoteConfigUpdate> _subscription;
  final StreamController<Set<String>> _remoteConfigKeysSetController;

  // Callback collections
  final Set<void Function(Either<CoreException, AppVersionUpdateModel>)>
  _versionUpdateCallbacks = {};
  final Set<void Function(Either<CoreException, AppMaintenanceModel>)>
  _maintenanceUpdateCallbacks = {};

  // Single subscription that notifies all callbacks
  StreamSubscription<Set<String>>? _configListenerSubscription;

  // Getters
  @override
  bool get isFetchSucceeded =>
      _firebaseRemoteConfig.lastFetchStatus == RemoteConfigFetchStatus.success;

  // Methods
  @override
  Future<void> init({
    required NetworkBase network,
    Duration fetchTimeout = const Duration(minutes: 1),
    Duration minimumFetchInterval = kDebugMode
        ? Duration.zero
        : const Duration(hours: 1),
  }) async {
    try {
      await _firebaseRemoteConfig.ensureInitialized();
      await _firebaseRemoteConfig.setDefaults({
        'app_version': AppVersionRemoteModel.def().toJson().toString(),
        'app_maintenance': AppMaintenanceModel.def().toJson(),
      });
      await _firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: fetchTimeout,
          minimumFetchInterval: minimumFetchInterval,
        ),
      );
      if (await network.isConnected) {
        await fetchAndActivate();
      }
    } on FirebaseException catch (e, st) {
      throw RemoteConfigFirebaseException(
        innerError: e,
        innerCode: e.code,
        innerMessage: e.message,
        st: st,
      );
    } catch (e) {
      throw RemoteConfigFirebaseException(innerError: e);
    }
  }

  @override
  Future<Either<CoreException, AppVersionUpdateModel>>
  getAppUpdateStatus() async {
    try {
      final json = _firebaseRemoteConfig.getString('app_version');

      if (json.isEmpty) {
        return left(
          const RemoteConfigFirebaseException(
            innerMessage: kDebugMode
                ? 'The app_version json is null, please '
                      'check that your firebase setup is correct'
                : null,
          ),
        );
      }

      final remoteAppVersion = AppVersionRemoteModel.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );

      final appVersion = await VersionHelper.appVersion();
      final isUpdateAvailable = appVersion.checkIfUpdateIsAvailable(
        remoteAppVersion,
      );

      return right(
        AppVersionUpdateModel(
          isUpdateAvailable: isUpdateAvailable,
          version: remoteAppVersion.version,
          buildNumber: remoteAppVersion.buildNumber,
          isOptional: remoteAppVersion.isOptional,
        ),
      );
    } on FirebaseException catch (e, st) {
      return left(
        RemoteConfigFirebaseException(
          innerError: e,
          innerCode: e.code,
          innerMessage: e.message,
          st: st,
        ),
      );
    } catch (e, st) {
      return left(RemoteConfigFirebaseException(innerError: e, st: st));
    }
  }

  @override
  void dispose() {
    // Clean up all config listeners
    clearConfigListeners();

    // Clean up main controller and subscription
    _remoteConfigKeysSetController.close();
    _subscription.cancel();
  }

  // Remove all listeners
  @visibleForTesting
  void clearConfigListeners() {
    _versionUpdateCallbacks.clear();
    _maintenanceUpdateCallbacks.clear();
    _configListenerSubscription?.cancel();
    _configListenerSubscription = null;
  }

  @override
  Stream<Set<String>> get configUpdatesStream =>
      _remoteConfigKeysSetController.stream;

  @override
  Future<void> fetchAndActivate() async {
    try {
      await _firebaseRemoteConfig.fetchAndActivate();
    } on FirebaseException catch (e, st) {
      throw RemoteConfigFirebaseException(
        innerError: e,
        innerCode: e.code,
        innerMessage: e.message,
        st: st,
      );
    } catch (e) {
      throw RemoteConfigFirebaseException(innerError: e);
    }
  }

  @override
  void addListener({
    void Function(Either<CoreException, AppVersionUpdateModel>)?
    onVersionUpdate,
    void Function(Either<CoreException, AppMaintenanceModel>)?
    onMaintenanceUpdate,
  }) {
    assert(
      onVersionUpdate != null || onMaintenanceUpdate != null,
      'At least one of onVersionUpdate or onMaintenanceUpdate must be provided',
    );

    // Add callbacks to appropriate sets
    if (onVersionUpdate != null) _versionUpdateCallbacks.add(onVersionUpdate);
    if (onMaintenanceUpdate != null) {
      _maintenanceUpdateCallbacks.add(onMaintenanceUpdate);
    }

    // Initialize the single subscription if it doesn't exist
    _configListenerSubscription ??= _remoteConfigKeysSetController.stream
        .listen(handleConfigUpdates);
  }

  @override
  void removeListener({
    void Function(Either<CoreException, AppVersionUpdateModel>)?
    onVersionUpdate,
    void Function(Either<CoreException, AppMaintenanceModel>)?
    onMaintenanceUpdate,
  }) {
    if (onVersionUpdate != null) {
      _versionUpdateCallbacks.remove(onVersionUpdate);
    }
    if (onMaintenanceUpdate != null) {
      _maintenanceUpdateCallbacks.remove(onMaintenanceUpdate);
    }

    // Cancel subscription if no more callbacks
    if (_versionUpdateCallbacks.isEmpty &&
        _maintenanceUpdateCallbacks.isEmpty) {
      _configListenerSubscription?.cancel();
      _configListenerSubscription = null;
    }
  }

  // Internal method to handle config updates
  @visibleForTesting
  Future<void> handleConfigUpdates(Set<String> updatedKeys) async {
    // Only continue if we have callbacks to invoke
    if (_versionUpdateCallbacks.isEmpty &&
        _maintenanceUpdateCallbacks.isEmpty) {
      return;
    }

    // Fetch and activate if we have listeners
    try {
      await fetchAndActivate();
    } catch (e) {
      // Continue even if fetch fails - we'll use cached values
    }

    // Process version updates if needed
    if (updatedKeys.contains('app_version') &&
        _versionUpdateCallbacks.isNotEmpty) {
      final versionResult = await getAppUpdateStatus();

      // Create a defensive copy to avoid concurrent modification
      final callbacksCopy =
          Set<void Function(Either<CoreException, AppVersionUpdateModel>)>.from(
            _versionUpdateCallbacks,
          );

      for (final callback in callbacksCopy) {
        // Check if the callback is still in the original set before calling
        if (_versionUpdateCallbacks.contains(callback)) {
          callback(versionResult);
        }
      }
    }

    // Process maintenance updates if needed
    if (updatedKeys.contains('app_maintenance') &&
        _maintenanceUpdateCallbacks.isNotEmpty) {
      final maintenanceResult = await getAppMaintenanceStatus();

      // Create a defensive copy to avoid concurrent modification
      final callbacksCopy =
          Set<void Function(Either<CoreException, AppMaintenanceModel>)>.from(
            _maintenanceUpdateCallbacks,
          );

      for (final callback in callbacksCopy) {
        // Check if the callback is still in the original set before calling
        if (_maintenanceUpdateCallbacks.contains(callback)) {
          callback(maintenanceResult);
        }
      }
    }
  }

  @override
  Future<Either<CoreException, AppMaintenanceModel>>
  getAppMaintenanceStatus() async {
    try {
      final json = _firebaseRemoteConfig.getString('app_maintenance');

      if (json.isEmpty) {
        return left(
          const RemoteConfigFirebaseException(
            innerMessage: kDebugMode
                ? 'The app_maintenance json is null, please '
                      'check that your firebase setup is correct'
                : null,
          ),
        );
      }

      final remoteAppMaintenance = AppMaintenanceModel.fromMap(
        jsonDecode(json) as Map<String, dynamic>,
      );

      return right(remoteAppMaintenance);
    } on FirebaseException catch (e, st) {
      return left(
        RemoteConfigFirebaseException(
          innerError: e,
          innerCode: e.code,
          innerMessage: e.message,
          st: st,
        ),
      );
    } catch (e, st) {
      return left(RemoteConfigFirebaseException(innerError: e, st: st));
    }
  }
}
