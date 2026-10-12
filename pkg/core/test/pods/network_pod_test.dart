import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:core/core.dart';
import 'package:core/network/network_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockConnectivityPlatform extends ConnectivityPlatform {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => [
    ConnectivityResult.wifi,
  ];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      const Stream.empty();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    ConnectivityPlatform.instance = _MockConnectivityPlatform();
  });

  group('networkPod', () {
    test('returns NetworkBase and accepts overrides', () {
      final fakeNetwork = _FakeNetwork();
      final container = ProviderContainer(
        overrides: [networkPod.overrideWithValue(fakeNetwork)],
      );
      addTearDown(container.dispose);

      expect(container.read(networkPod), same(fakeNetwork));
    });

    test('default provider builds NetworkImpl', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(networkPod), isA<NetworkImpl>());
      await pumpEventQueue();
    });
  });
}

final class _FakeNetwork implements NetworkBase {
  @override
  void addListener({void Function()? onOnline, void Function()? onOffline}) {}

  @override
  Stream<NetworkStatus> get connectionStatusStream => const Stream.empty();

  @override
  void dispose() {}

  @override
  Future<bool> get isConnected async => true;

  @override
  void removeListener({
    void Function()? onOnline,
    void Function()? onOffline,
  }) {}
}
