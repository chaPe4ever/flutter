import 'dart:async';
import 'dart:convert';
import 'dart:developer';

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
    _subscription = _firebaseRemoteConfig.onConfigUpdated.distinct().listen(
      (RemoteConfigUpdate result) {
        _remoteConfigKeysSetController.add(result.updatedKeys);
      },
      onError: (dynamic e, StackTrace st) {
        // TODO(Everyone): Open Bug
        //https://github.com/firebase/flutterfire/issues/10780
        if (e is PlatformException) {
          log(
            e.message ?? e.details.toString(),
            error: e,
            stackTrace:
                e.stacktrace != null
                    ? StackTrace.fromString(e.stacktrace!)
                    : st,
            level: 1000,
          );
        }
      },
    );
  }

  // Fields
  final FirebaseRemoteConfig _firebaseRemoteConfig;
  late final StreamSubscription<RemoteConfigUpdate> _subscription;
  final StreamController<Set<String>> _remoteConfigKeysSetController;

  // Getters
  @override
  bool get isFetchSucceeded =>
      _firebaseRemoteConfig.lastFetchStatus == RemoteConfigFetchStatus.success;

  // Methods
  @override
  Future<void> init({
    required NetworkBase network,
    Duration fetchTimeout = const Duration(minutes: 1),
    Duration minimumFetchInterval =
        kDebugMode ? Duration.zero : const Duration(hours: 1),
  }) async {
    try {
      await _firebaseRemoteConfig.ensureInitialized();
      await _firebaseRemoteConfig.setDefaults({
        'app_version':
            const AppVersionRemoteModel(
              version: '1.0.0',
              buildNumber: 1,
              isOptional: false,
            ).toJson().toString(),
        'app_maintenance': const AppMaintenanceModel(isActive: false).toJson(),
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
            innerMessage:
                kDebugMode
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
    _remoteConfigKeysSetController.close();
    _subscription.cancel();
  }

  @override
  StreamController<Set<String>> get remoteConfigUpdatesController =>
      _remoteConfigKeysSetController;

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
  void configUpdatesListener({
    void Function(Either<CoreException, AppVersionUpdateModel> cb)?
    onVersionUpdate,
    void Function(Either<CoreException, AppMaintenanceModel> cb)?
    onMaintenanceUpdate,
  }) {
    _remoteConfigKeysSetController.stream.listen((config) async {
      if (onVersionUpdate != null || onMaintenanceUpdate != null) {
        await fetchAndActivate();
      }

      if (config.contains('app_version')) {
        if (onVersionUpdate != null) {
          final cb = await getAppUpdateStatus();
          onVersionUpdate.call(cb);
        }
      }
      if (config.contains('app_maintenance')) {
        if (onMaintenanceUpdate != null) {
          final cb = await getAppMaintenanceStatus();
          onMaintenanceUpdate.call(cb);
        }
      }
    });
  }

  @override
  Future<Either<CoreException, AppMaintenanceModel>>
  getAppMaintenanceStatus() async {
    try {
      final json = _firebaseRemoteConfig.getString('app_maintenance');

      if (json.isEmpty) {
        return left(
          const RemoteConfigFirebaseException(
            innerMessage:
                kDebugMode
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
