import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';

final class FakeFirebaseRemoteConfigPlatform
    extends FirebaseRemoteConfigPlatform {
  FakeFirebaseRemoteConfigPlatform({FirebaseApp? app})
    : super(appInstance: app);

  final StreamController<RemoteConfigUpdate> configUpdatesController =
      StreamController<RemoteConfigUpdate>.broadcast();

  final StreamController<RemoteConfigUpdate> overrideConfigUpdatesController =
      StreamController<RemoteConfigUpdate>.broadcast();

  bool useOverrideConfigUpdatesStream = false;

  RemoteConfigFetchStatus fetchStatus = RemoteConfigFetchStatus.success;
  Map<String, String> stringValues = <String, String>{};
  Exception? ensureInitializedError;
  Exception? fetchAndActivateError;
  Exception? getStringError;

  int ensureInitializedCalls = 0;
  int setDefaultsCalls = 0;
  int setConfigSettingsCalls = 0;
  int fetchAndActivateCalls = 0;
  Map<String, dynamic>? lastDefaults;
  RemoteConfigSettings? lastSettings;

  @override
  FirebaseRemoteConfigPlatform delegateFor({required FirebaseApp app}) => this;

  @override
  FirebaseRemoteConfigPlatform setInitialValues({
    required Map<dynamic, dynamic> remoteConfigValues,
  }) => this;

  @override
  Stream<RemoteConfigUpdate> get onConfigUpdated {
    if (useOverrideConfigUpdatesStream) {
      return overrideConfigUpdatesController.stream;
    }
    return configUpdatesController.stream;
  }

  @override
  RemoteConfigFetchStatus get lastFetchStatus => fetchStatus;

  @override
  DateTime get lastFetchTime => DateTime.utc(2020);

  @override
  RemoteConfigSettings get settings => RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 1),
  );

  @override
  Future<void> ensureInitialized() async {
    ensureInitializedCalls++;
    final error = ensureInitializedError;
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<void> setDefaults(Map<String, dynamic> defaultParameters) async {
    setDefaultsCalls++;
    lastDefaults = defaultParameters;
  }

  @override
  Future<void> setConfigSettings(
    RemoteConfigSettings remoteConfigSettings,
  ) async {
    setConfigSettingsCalls++;
    lastSettings = remoteConfigSettings;
  }

  @override
  Future<bool> fetchAndActivate() async {
    fetchAndActivateCalls++;
    final error = fetchAndActivateError;
    if (error != null) {
      throw error;
    }
    return true;
  }

  @override
  String getString(String key) {
    final error = getStringError;
    if (error != null) {
      throw error;
    }
    return stringValues[key] ?? '';
  }

  void resetBehavior() {
    stringValues = <String, String>{};
    ensureInitializedError = null;
    fetchAndActivateError = null;
    getStringError = null;
    fetchStatus = RemoteConfigFetchStatus.success;
    ensureInitializedCalls = 0;
    setDefaultsCalls = 0;
    setConfigSettingsCalls = 0;
    fetchAndActivateCalls = 0;
    lastDefaults = null;
    lastSettings = null;
    useOverrideConfigUpdatesStream = false;
  }

  Future<void> dispose() async {
    if (!configUpdatesController.isClosed) {
      await configUpdatesController.close();
    }
    if (!overrideConfigUpdatesController.isClosed) {
      await overrideConfigUpdatesController.close();
    }
  }
}
