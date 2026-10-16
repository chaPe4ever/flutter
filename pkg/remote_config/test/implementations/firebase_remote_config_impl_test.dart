import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_config/exceptions/remote_config_exceptions.dart';
import 'package:remote_config/implementations/firebase_remote_config_impl.dart';
import 'package:remote_config/models/app_maintenance_model.dart';
import 'package:remote_config/models/app_version_model.dart';

import '../helpers/fake_network.dart';
import '../helpers/firebase_remote_config_test_setup.dart';

void main() {
  late FirebaseRemoteConfig firebaseRemoteConfig;
  late FirebaseRemoteConfigImpl impl;

  setUpAll(() async {
    registerRemoteConfigTestFallbacks();
    firebaseRemoteConfig = await setupFirebaseRemoteConfigForTests();
  });

  setUp(() async {
    activeRemoteConfigPlatform.resetBehavior();
    await mockPackageInfo();
    impl = FirebaseRemoteConfigImpl(firebaseRemoteConfig: firebaseRemoteConfig);
  });

  tearDown(() {
    impl.dispose();
    clearPackageInfoMock();
  });

  tearDownAll(tearDownFirebaseRemoteConfigForTests);

  group('isFetchSucceeded', () {
    test('reflects last fetch status from Firebase', () {
      activeRemoteConfigPlatform.fetchStatus = RemoteConfigFetchStatus.failure;
      expect(impl.isFetchSucceeded, isFalse);

      activeRemoteConfigPlatform.fetchStatus = RemoteConfigFetchStatus.success;
      expect(impl.isFetchSucceeded, isTrue);
    });
  });

  group('init', () {
    test('initializes defaults and fetches when online', () async {
      await impl.init(network: FakeNetwork());

      expect(activeRemoteConfigPlatform.ensureInitializedCalls, 1);
      expect(activeRemoteConfigPlatform.setDefaultsCalls, 1);
      expect(activeRemoteConfigPlatform.setConfigSettingsCalls, 1);
      expect(activeRemoteConfigPlatform.fetchAndActivateCalls, 1);
    });

    test('skips fetch when offline', () async {
      await impl.init(network: FakeNetwork(connected: false));

      expect(activeRemoteConfigPlatform.fetchAndActivateCalls, 0);
    });

    test('wraps FirebaseException', () async {
      activeRemoteConfigPlatform.ensureInitializedError = FirebaseException(
        plugin: 'remote_config',
        code: 'init-failed',
      );

      await expectLater(
        impl.init(network: FakeNetwork()),
        throwsA(isA<RemoteConfigFirebaseException>()),
      );
    });

    test('wraps generic exceptions', () async {
      activeRemoteConfigPlatform.ensureInitializedError = Exception('boom');

      await expectLater(
        impl.init(network: FakeNetwork()),
        throwsA(isA<RemoteConfigFirebaseException>()),
      );
    });
  });

  group('fetchAndActivate', () {
    test('delegates to Firebase', () async {
      await impl.fetchAndActivate();
      expect(activeRemoteConfigPlatform.fetchAndActivateCalls, 1);
    });

    test('wraps FirebaseException', () async {
      activeRemoteConfigPlatform.fetchAndActivateError = FirebaseException(
        plugin: 'remote_config',
        code: 'fetch-failed',
      );

      await expectLater(
        impl.fetchAndActivate(),
        throwsA(isA<RemoteConfigFirebaseException>()),
      );
    });

    test('wraps generic exceptions', () async {
      activeRemoteConfigPlatform.fetchAndActivateError = Exception(
        'fetch failed',
      );

      await expectLater(
        impl.fetchAndActivate(),
        throwsA(isA<RemoteConfigFirebaseException>()),
      );
    });
  });

  group('getAppUpdateStatus', () {
    test('returns left when app_version is empty with debug message', () async {
      final result = await impl.getAppUpdateStatus();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(
          error.innerMessage,
          contains('app_version json is null'),
        ),
        (_) => fail('expected left'),
      );
    });

    test('returns left without debug message when flag disabled', () async {
      final releaseStyleImpl = FirebaseRemoteConfigImpl(
        firebaseRemoteConfig: firebaseRemoteConfig,
        emitDebugInnerMessages: false,
      );
      addTearDown(releaseStyleImpl.dispose);

      final result = await releaseStyleImpl.getAppUpdateStatus();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error.innerMessage, isNull),
        (_) => fail('expected left'),
      );
    });

    test('detects when a remote update is available', () async {
      activeRemoteConfigPlatform.stringValues['app_version'] = jsonEncode(
        const AppVersionRemoteModel(
          version: '2.0.0',
          buildNumber: 2,
          isOptional: false,
        ).toJson(),
      );

      final result = await impl.getAppUpdateStatus();

      expect(
        result.getOrCrash(),
        const AppVersionUpdateModel(
          version: '2.0.0',
          buildNumber: 2,
          isOptional: false,
          isUpdateAvailable: true,
        ),
      );
    });

    test('returns left when json is invalid', () async {
      activeRemoteConfigPlatform.stringValues['app_version'] = 'not-json';

      final result = await impl.getAppUpdateStatus();
      expect(result.isLeft(), isTrue);
    });

    test('returns left when Firebase throws', () async {
      activeRemoteConfigPlatform.getStringError = FirebaseException(
        plugin: 'remote_config',
        code: 'read-failed',
      );

      final result = await impl.getAppUpdateStatus();
      expect(result.isLeft(), isTrue);
    });
  });

  group('getAppMaintenanceStatus', () {
    test('returns maintenance model from remote config', () async {
      activeRemoteConfigPlatform.stringValues['app_maintenance'] = jsonEncode(
        const AppMaintenanceModel(isActive: true).toMap(),
      );

      final result = await impl.getAppMaintenanceStatus();

      expect(result.getOrCrash(), const AppMaintenanceModel(isActive: true));
    });

    test('returns left when app_maintenance is empty', () async {
      final result = await impl.getAppMaintenanceStatus();
      expect(result.isLeft(), isTrue);
    });

    test('returns left without debug message when flag disabled', () async {
      final releaseStyleImpl = FirebaseRemoteConfigImpl(
        firebaseRemoteConfig: firebaseRemoteConfig,
        emitDebugInnerMessages: false,
      );
      addTearDown(releaseStyleImpl.dispose);

      final result = await releaseStyleImpl.getAppMaintenanceStatus();
      result.fold(
        (error) => expect(error.innerMessage, isNull),
        (_) => fail('expected left'),
      );
    });

    test('returns left when json is invalid', () async {
      activeRemoteConfigPlatform.stringValues['app_maintenance'] = '{bad';

      final result = await impl.getAppMaintenanceStatus();
      expect(result.isLeft(), isTrue);
    });

    test('returns left when Firebase throws', () async {
      activeRemoteConfigPlatform.getStringError = FirebaseException(
        plugin: 'remote_config',
        code: 'read-failed',
      );

      final result = await impl.getAppMaintenanceStatus();
      expect(result.isLeft(), isTrue);
    });
  });

  group('config update stream', () {
    test('forwards updated keys from Firebase', () async {
      final seen = <Set<String>>[];
      final sub = impl.configUpdatesStream.listen(seen.add);
      addTearDown(sub.cancel);

      activeRemoteConfigPlatform.configUpdatesController.add(
        RemoteConfigUpdate(<String>{'app_version'}),
      );
      await Future<void>.delayed(Duration.zero);

      expect(seen.single, {'app_version'});
    });

    test('logs PlatformException errors from Firebase stream', () async {
      activeRemoteConfigPlatform.useOverrideConfigUpdatesStream = true;
      final loggingImpl = FirebaseRemoteConfigImpl(
        firebaseRemoteConfig: firebaseRemoteConfig,
      );
      addTearDown(loggingImpl.dispose);

      activeRemoteConfigPlatform.overrideConfigUpdatesController.addError(
        PlatformException(
          code: 'config-stream',
          message: 'stream failed',
          stacktrace: StackTrace.current.toString(),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      activeRemoteConfigPlatform.overrideConfigUpdatesController.addError(
        PlatformException(code: 'no-stack', message: 'no stack'),
        StackTrace.current,
      );
      await Future<void>.delayed(Duration.zero);

      activeRemoteConfigPlatform.overrideConfigUpdatesController.addError(
        Exception('ignored'),
      );
      await Future<void>.delayed(Duration.zero);
    });
  });

  group('listeners', () {
    test('asserts when no callbacks are provided', () {
      expect(() => impl.addListener(), throwsAssertionError);
    });

    test('notifies version listeners after config updates', () async {
      Either<CoreException, AppVersionUpdateModel>? seen;
      impl.addListener(
        onVersionUpdate: (result) => seen = result,
      );

      activeRemoteConfigPlatform.stringValues['app_version'] = jsonEncode(
        const AppVersionRemoteModel(
          version: '9.0.0',
          buildNumber: 9,
          isOptional: true,
        ).toJson(),
      );

      await impl.handleConfigUpdates({'app_version'});
      expect(seen?.isRight(), isTrue);
    });

    test('notifies maintenance listeners after config updates', () async {
      Either<CoreException, AppMaintenanceModel>? seen;
      impl.addListener(onMaintenanceUpdate: (result) => seen = result);

      activeRemoteConfigPlatform.stringValues['app_maintenance'] = jsonEncode(
        const AppMaintenanceModel(isActive: true).toMap(),
      );

      await impl.handleConfigUpdates({'app_maintenance'});
      expect(seen?.getOrCrash(), const AppMaintenanceModel(isActive: true));
    });

    test('continues when fetch fails during handleConfigUpdates', () async {
      activeRemoteConfigPlatform.fetchAndActivateError = Exception('offline');
      Either<CoreException, AppMaintenanceModel>? seen;
      impl.addListener(onMaintenanceUpdate: (result) => seen = result);

      activeRemoteConfigPlatform.stringValues['app_maintenance'] = jsonEncode(
        const AppMaintenanceModel(isActive: false).toMap(),
      );

      await impl.handleConfigUpdates({'app_maintenance'});
      expect(seen?.getOrCrash(), const AppMaintenanceModel(isActive: false));
    });

    test('returns early when there are no callbacks', () async {
      await impl.handleConfigUpdates({'app_version'});
      expect(activeRemoteConfigPlatform.fetchAndActivateCalls, 0);
    });

    test('removeListener cancels the shared subscription', () async {
      void onVersion(Either<CoreException, AppVersionUpdateModel> _) {}
      impl
        ..addListener(onVersionUpdate: onVersion)
        ..removeListener(onVersionUpdate: onVersion);

      await impl.handleConfigUpdates({'app_version'});
      expect(activeRemoteConfigPlatform.fetchAndActivateCalls, 0);
    });

    test('removeListener drops maintenance callbacks', () async {
      void onMaintenance(Either<CoreException, AppMaintenanceModel> _) {}
      impl
        ..addListener(onMaintenanceUpdate: onMaintenance)
        ..removeListener(onMaintenanceUpdate: onMaintenance);

      await impl.handleConfigUpdates({'app_maintenance'});
      expect(activeRemoteConfigPlatform.fetchAndActivateCalls, 0);
    });

    test('skips callbacks removed before invocation', () async {
      var calls = 0;
      void onVersion(Either<CoreException, AppVersionUpdateModel> _) {
        calls++;
        impl.removeListener(onVersionUpdate: onVersion);
      }

      impl.addListener(onVersionUpdate: onVersion);
      activeRemoteConfigPlatform.stringValues['app_version'] = jsonEncode(
        AppVersionRemoteModel.def().toJson(),
      );

      await impl.handleConfigUpdates({'app_version'});
      expect(calls, 1);
    });

    test('clearConfigListeners removes active callbacks', () {
      void onVersion(Either<CoreException, AppVersionUpdateModel> _) {}
      impl
        ..addListener(onVersionUpdate: onVersion)
        ..clearConfigListeners();
      expect(impl.configUpdatesStream, isA<Stream<Set<String>>>());
    });
  });

  group('typed getters', () {
    test('uses the fallback when the key was never configured', () {
      expect(impl.getString('missing', fallback: 'local'), 'local');
      expect(impl.getInt('missing', fallback: 7), 7);
      expect(impl.getBool('missing', fallback: true), isTrue);
    });

    test('returns the static default when no fallback is given', () {
      expect(impl.getString('missing'), isEmpty);
      expect(impl.getInt('missing'), 0);
      expect(impl.getBool('missing'), isFalse);
    });

    test('returns a fetched value, including zero and false', () {
      activeRemoteConfigPlatform.configuredValues.addAll({
        'label': TestRemoteConfigValue('live', ValueSource.valueRemote),
        'count': TestRemoteConfigValue('0', ValueSource.valueRemote),
        'flag': TestRemoteConfigValue('false', ValueSource.valueRemote),
      });

      expect(impl.getString('label', fallback: 'local'), 'live');
      expect(impl.getInt('count', fallback: 7), 0);
      expect(impl.getBool('flag', fallback: true), isFalse);
    });

    test('returns an in-app default instead of the fallback', () {
      activeRemoteConfigPlatform.configuredValues['count'] =
          TestRemoteConfigValue('3', ValueSource.valueDefault);

      expect(impl.getInt('count', fallback: 7), 3);
    });

    test('returns the fallback when the read fails', () {
      activeRemoteConfigPlatform.getValueError = FirebaseException(
        plugin: 'remote_config',
        code: 'read-failed',
      );

      expect(impl.getInt('count', fallback: 7), 7);
      expect(impl.getString('label'), isEmpty);
      expect(impl.getBool('flag'), isFalse);
    });
  });

  group('dispose', () {
    test('closes internal resources', () async {
      final localImpl = FirebaseRemoteConfigImpl(
        firebaseRemoteConfig: firebaseRemoteConfig,
      );
      final events = <Set<String>>[];
      final sub = localImpl.configUpdatesStream.listen(events.add);
      localImpl.dispose();
      await sub.cancel();

      activeRemoteConfigPlatform.configUpdatesController.add(
        RemoteConfigUpdate(<String>{'app_version'}),
      );
      await Future<void>.delayed(Duration.zero);
      expect(events, isEmpty);
    });
  });
}
