import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/network/network_impl.dart';
import 'package:core/network/network_status.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeConnectivity extends Fake implements Connectivity {
  FakeConnectivity({
    required Stream<List<ConnectivityResult>> onChanged,
    this.checkResults = const [ConnectivityResult.wifi],
    this.throwOnCheck = false,
  }) : _onChanged = onChanged;

  final Stream<List<ConnectivityResult>> _onChanged;
  List<ConnectivityResult> checkResults;
  final bool throwOnCheck;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _onChanged;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    if (throwOnCheck) {
      throw Exception('connectivity failed');
    }
    return checkResults;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NetworkImpl', () {
    Future<NetworkImpl> buildNetwork({
      List<ConnectivityResult>? checkResults,
      StreamController<List<ConnectivityResult>>? controller,
    }) async {
      final streamController =
          controller ?? StreamController<List<ConnectivityResult>>.broadcast();
      final network = NetworkImpl(
        connectivity: FakeConnectivity(
          onChanged: streamController.stream,
          checkResults: checkResults ?? [ConnectivityResult.wifi],
        ),
      );
      await pumpEventQueue();
      return network;
    }

    test('getStatusFromResult maps connectivity results', () async {
      final network = await buildNetwork();

      expect(
        network.getStatusFromResult(ConnectivityResult.wifi),
        NetworkStatus.wifi,
      );
      expect(
        network.getStatusFromResult(ConnectivityResult.mobile),
        NetworkStatus.cellular,
      );
      expect(
        network.getStatusFromResult(ConnectivityResult.none),
        NetworkStatus.offline,
      );
      expect(
        network.getStatusFromResult(ConnectivityResult.bluetooth),
        NetworkStatus.other,
      );
      expect(
        network.getStatusFromResult(ConnectivityResult.ethernet),
        NetworkStatus.other,
      );
      expect(
        network.getStatusFromResult(ConnectivityResult.vpn),
        NetworkStatus.other,
      );
      expect(
        network.getStatusFromResult(ConnectivityResult.satellite),
        NetworkStatus.other,
      );
      expect(
        network.getStatusFromResult(ConnectivityResult.other),
        NetworkStatus.other,
      );

      network.dispose();
    });

    test('isConnected returns true when any result is not none', () async {
      final network = await buildNetwork(
        checkResults: [ConnectivityResult.wifi],
      );

      await expectLater(network.isConnected, completion(isTrue));

      network.dispose();
    });

    test('isConnected returns true when connectivity list is empty', () async {
      final network = await buildNetwork(checkResults: []);

      await expectLater(network.isConnected, completion(isTrue));

      network.dispose();
    });

    test('isConnected returns false when checkConnectivity throws', () async {
      final streamController =
          StreamController<List<ConnectivityResult>>.broadcast();
      final network = NetworkImpl(
        connectivity: FakeConnectivity(
          onChanged: streamController.stream,
          throwOnCheck: true,
        ),
      );
      await pumpEventQueue();

      await expectLater(network.isConnected, completion(isFalse));

      network.dispose();
      await streamController.close();
    });

    test('emits offline when connectivity stream is empty', () async {
      final controller = StreamController<List<ConnectivityResult>>.broadcast();
      final network = await buildNetwork(controller: controller);
      NetworkStatus? latest;
      final sub = network.connectionStatusStream.listen((s) => latest = s);

      controller.add([]);
      await pumpEventQueue();

      expect(latest, NetworkStatus.offline);
      await sub.cancel();
      network.dispose();
      await controller.close();
    });

    test('isConnected returns false when only none is reported', () async {
      final network = await buildNetwork(
        checkResults: [ConnectivityResult.none],
      );

      await expectLater(network.isConnected, completion(isFalse));

      network.dispose();
    });

    test('notifies online and offline listeners on stream updates', () async {
      final controller = StreamController<List<ConnectivityResult>>.broadcast();
      final network = await buildNetwork(controller: controller);
      var onlineCalls = 0;
      var offlineCalls = 0;

      network.addListener(
        onOnline: () => onlineCalls++,
        onOffline: () => offlineCalls++,
      );

      controller.add([ConnectivityResult.none]);
      await pumpEventQueue();
      expect(offlineCalls, 1);

      controller.add([ConnectivityResult.wifi]);
      await pumpEventQueue();
      expect(onlineCalls, 1);

      network.dispose();
      await controller.close();
    });

    test(
      'removeListener cancels subscription when last callback removed',
      () async {
        final controller =
            StreamController<List<ConnectivityResult>>.broadcast();
        final network = await buildNetwork(controller: controller);
        var onlineCalls = 0;

        void onOnline() => onlineCalls++;

        network
          ..addListener(onOnline: onOnline)
          ..removeListener(onOnline: onOnline);

        controller.add([ConnectivityResult.wifi]);
        await pumpEventQueue();

        expect(onlineCalls, 0);
        network.dispose();
        await controller.close();
      },
    );

    test('removeListener removes offline callback only', () async {
      final controller = StreamController<List<ConnectivityResult>>.broadcast();
      final network = await buildNetwork(controller: controller);
      var offlineCalls = 0;

      void onOffline() => offlineCalls++;

      network
        ..addListener(onOffline: onOffline)
        ..removeListener(onOffline: onOffline);

      controller.add([ConnectivityResult.none]);
      await pumpEventQueue();

      expect(offlineCalls, 0);
      network.dispose();
      await controller.close();
    });

    test('removeListener stops callbacks and allows dispose', () async {
      final controller = StreamController<List<ConnectivityResult>>.broadcast();
      final network = await buildNetwork(controller: controller);
      var onlineCalls = 0;

      void onOnline() => onlineCalls++;

      network
        ..addListener(onOnline: onOnline)
        ..removeListener(onOnline: onOnline);

      controller.add([ConnectivityResult.wifi]);
      await pumpEventQueue();

      expect(onlineCalls, 0);
      expect(network.dispose, returnsNormally);
      await controller.close();
    });
  });
}
