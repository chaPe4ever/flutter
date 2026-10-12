import 'dart:async';

import 'package:core/core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setupFirebaseCoreMocks);

  setUp(() async {
    try {
      await Firebase.initializeApp();
    } on FirebaseException catch (e) {
      if (e.code != 'duplicate-app') {
        rethrow;
      }
    }
  });

  group('firebase pods', () {
    test(
      'firestorePod registers network listeners and disposes cleanly',
      () async {
        final network = _TrackingNetwork();
        final gateway = _RecordingFirestoreNetworkGateway();
        final container = ProviderContainer(
          overrides: [
            networkPod.overrideWithValue(network),
            firestoreNetworkGatewayPod.overrideWithValue(gateway),
          ],
        );
        addTearDown(() {
          container.dispose();
          expect(network.removeListenerCalls, 1);
        });

        expect(container.read(firestorePod), isNotNull);
        expect(network.addListenerCalls, 1);
        expect(network.onOnline, isNotNull);
        expect(network.onOffline, isNotNull);

        network.onOnline?.call();
        network.onOffline?.call();
        await gateway.flushPending();

        expect(gateway.enableCalls, 1);
        expect(gateway.disableCalls, 1);
      },
    );

    test('firestorePod uses emulator settings when override is true', () {
      final container = ProviderContainer(
        overrides: [useFirebaseEmulatorsPod.overrideWithValue(true)],
      );
      addTearDown(container.dispose);

      expect(container.read(firestorePod), isNotNull);
    });

    test('functionsPod returns FirebaseFunctions for region', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(functionsPod()), isNotNull);
    });

    test('firebaseDbPod returns FirebaseDatabase instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(firebaseDbPod), isNotNull);
    });
  });
}

final class _TrackingNetwork implements NetworkBase {
  int addListenerCalls = 0;
  int removeListenerCalls = 0;
  VoidCallback? onOnline;
  VoidCallback? onOffline;

  @override
  void addListener({VoidCallback? onOnline, VoidCallback? onOffline}) {
    addListenerCalls++;
    this.onOnline = onOnline;
    this.onOffline = onOffline;
  }

  @override
  void removeListener({VoidCallback? onOnline, VoidCallback? onOffline}) {
    removeListenerCalls++;
    if (onOnline != null) {
      this.onOnline = null;
    }
    if (onOffline != null) {
      this.onOffline = null;
    }
  }

  @override
  Stream<NetworkStatus> get connectionStatusStream => const Stream.empty();

  @override
  void dispose() {}

  @override
  Future<bool> get isConnected async => true;
}

final class _RecordingFirestoreNetworkGateway
    implements FirestoreNetworkGateway {
  int enableCalls = 0;
  int disableCalls = 0;
  final _pending = <Future<void>>[];

  @override
  Future<void> enableNetwork() {
    enableCalls++;
    final completer = Completer<void>()..complete();
    _pending.add(completer.future);
    return completer.future;
  }

  @override
  Future<void> disableNetwork() {
    disableCalls++;
    final completer = Completer<void>()..complete();
    _pending.add(completer.future);
    return completer.future;
  }

  Future<void> flushPending() => Future.wait(_pending);
}
