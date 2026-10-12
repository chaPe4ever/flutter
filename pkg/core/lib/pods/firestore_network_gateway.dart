import 'package:core/core.dart';

part 'firestore_network_gateway.g.dart';

/// Bridges connectivity events to Firestore network APIs
/// (overridable in tests).
abstract interface class FirestoreNetworkGateway {
  Future<void> enableNetwork();

  Future<void> disableNetwork();
}

final class FirebaseFirestoreNetworkGateway implements FirestoreNetworkGateway {
  FirebaseFirestoreNetworkGateway([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> enableNetwork() => _firestore.enableNetwork();

  @override
  Future<void> disableNetwork() => _firestore.disableNetwork();
}

@Riverpod(keepAlive: true)
FirestoreNetworkGateway firestoreNetworkGateway(Ref ref) =>
    FirebaseFirestoreNetworkGateway();
