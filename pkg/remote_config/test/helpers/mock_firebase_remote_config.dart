import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mocktail/mocktail.dart';

final class TestRemoteConfigValue extends RemoteConfigValue {
  TestRemoteConfigValue(String raw, ValueSource source)
    : super(utf8.encode(raw), source);
}

class MockFirebaseRemoteConfig extends Mock implements FirebaseRemoteConfig {}

void registerRemoteConfigTestFallbacks() {
  registerFallbackValue(
    RemoteConfigSettings(
      fetchTimeout: Duration.zero,
      minimumFetchInterval: Duration.zero,
    ),
  );
}

var _firebaseRemoteConfigMocktailFallbacksRegistered = false;

void _registerFirebaseRemoteConfigMocktailFallbacks() {
  if (_firebaseRemoteConfigMocktailFallbacksRegistered) {
    return;
  }
  registerFallbackValue(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );
  registerFallbackValue(<String, dynamic>{});
  _firebaseRemoteConfigMocktailFallbacksRegistered = true;
}

class FirebaseRemoteConfigTestHarness {
  FirebaseRemoteConfigTestHarness() : mock = MockFirebaseRemoteConfig() {
    _registerFirebaseRemoteConfigMocktailFallbacks();
    _wireDefaults();
  }

  final MockFirebaseRemoteConfig mock;

  final StreamController<RemoteConfigUpdate> configUpdatesController =
      StreamController<RemoteConfigUpdate>.broadcast();

  final StreamController<RemoteConfigUpdate> overrideConfigUpdatesController =
      StreamController<RemoteConfigUpdate>.broadcast();

  bool useOverrideConfigUpdatesStream = false;

  RemoteConfigFetchStatus fetchStatus = RemoteConfigFetchStatus.success;
  Map<String, String> stringValues = <String, String>{};
  Map<String, TestRemoteConfigValue> configuredValues =
      <String, TestRemoteConfigValue>{};
  Exception? ensureInitializedError;
  Exception? fetchAndActivateError;
  Exception? getStringError;
  Exception? getValueError;

  int ensureInitializedCalls = 0;
  int setDefaultsCalls = 0;
  int setConfigSettingsCalls = 0;
  int fetchAndActivateCalls = 0;
  Map<String, dynamic>? lastDefaults;
  RemoteConfigSettings? lastSettings;

  Future<void> _ensureInitialized(Invocation _) async {
    ensureInitializedCalls++;
    final error = ensureInitializedError;
    if (error != null) {
      throw error;
    }
  }

  Future<void> _setDefaults(Invocation invocation) async {
    setDefaultsCalls++;
    lastDefaults = invocation.positionalArguments.first as Map<String, dynamic>;
  }

  Future<bool> _fetchAndActivate(Invocation _) async {
    fetchAndActivateCalls++;
    final error = fetchAndActivateError;
    if (error != null) {
      throw error;
    }
    return true;
  }

  Future<void> _setConfigSettings(Invocation invocation) async {
    setConfigSettingsCalls++;
    lastSettings = invocation.positionalArguments.first as RemoteConfigSettings;
  }

  String _getString(Invocation invocation) {
    final error = getStringError;
    if (error != null) {
      throw error;
    }
    final key = invocation.positionalArguments.first as String;
    return stringValues[key] ?? '';
  }

  RemoteConfigValue _getValue(Invocation invocation) {
    final error = getValueError;
    if (error != null) {
      throw error;
    }
    final key = invocation.positionalArguments.first as String;
    return configuredValues[key] ??
        TestRemoteConfigValue('', ValueSource.valueStatic);
  }

  Stream<RemoteConfigUpdate> _configUpdates(Invocation _) {
    if (useOverrideConfigUpdatesStream) {
      return overrideConfigUpdatesController.stream;
    }
    return configUpdatesController.stream;
  }

  RemoteConfigFetchStatus _lastFetchStatus(Invocation _) => fetchStatus;

  void _wireDefaults() {
    when(() => mock.lastFetchStatus).thenAnswer(_lastFetchStatus);
    when(() => mock.settings).thenReturn(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    when(() => mock.onConfigUpdated).thenAnswer(_configUpdates);
    // mocktail [when] requires a closure around the stubbed invocation.
    // ignore: unnecessary_lambdas
    when(() => mock.ensureInitialized()).thenAnswer(_ensureInitialized);
    when(() => mock.setDefaults(any())).thenAnswer(_setDefaults);
    when(() => mock.setConfigSettings(any())).thenAnswer(_setConfigSettings);
    // mocktail [when] requires a closure around the stubbed invocation.
    // ignore: unnecessary_lambdas
    when(() => mock.fetchAndActivate()).thenAnswer(_fetchAndActivate);
    when(() => mock.getString(any())).thenAnswer(_getString);
    when(() => mock.getValue(any())).thenAnswer(_getValue);
  }

  void resetBehavior() {
    stringValues = <String, String>{};
    configuredValues = <String, TestRemoteConfigValue>{};
    ensureInitializedError = null;
    fetchAndActivateError = null;
    getStringError = null;
    getValueError = null;
    fetchStatus = RemoteConfigFetchStatus.success;
    ensureInitializedCalls = 0;
    setDefaultsCalls = 0;
    setConfigSettingsCalls = 0;
    fetchAndActivateCalls = 0;
    lastDefaults = null;
    lastSettings = null;
    useOverrideConfigUpdatesStream = false;
    reset(mock);
    _wireDefaults();
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

FirebaseRemoteConfigTestHarness? _activeHarness;

FirebaseRemoteConfigTestHarness get activeRemoteConfigHarness {
  final harness = _activeHarness;
  if (harness == null) {
    throw StateError('Call setupFirebaseRemoteConfigForTests() first.');
  }
  return harness;
}

/// Backwards-compatible alias used by existing tests.
FirebaseRemoteConfigTestHarness get activeRemoteConfigPlatform =>
    activeRemoteConfigHarness;

Future<FirebaseRemoteConfig> setupFirebaseRemoteConfigForTests() async {
  _activeHarness ??= FirebaseRemoteConfigTestHarness();
  return _activeHarness!.mock;
}

Future<void> tearDownFirebaseRemoteConfigForTests() async {
  await _activeHarness?.dispose();
  _activeHarness = null;
}
