import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoreEx derivatives', () {
    test('use the core package prefix in toString', () {
      expect(
        const StorageInitialisationException().toString(),
        contains('core : storage_initialisation_exception_message_key'),
      );
      expect(
        const NoNetworkException().toString(),
        contains('core : no_network_exception_message_key'),
      );
      expect(
        LaunchUrlException().toString(),
        contains('core : launch_url_exception_message_key'),
      );
    });

    test('ClientVisibleException keeps a custom message key', () {
      expect(
        const ClientVisibleException(messageKey: 'visible_error').toString(),
        'core : visible_error',
      );
    });

    test('Firestore and network-related exceptions default message keys', () {
      final exceptions = <CoreException>[
        FirestoreException(),
        FirestoreNullDocumentSnapshotException(),
        MaxRefreshTokenRetriesReached(),
        DioClientException(),
        UnInitialisedFlavorException(),
        FirestoreFunctionsException(),
        UnknownCoreException(),
      ];

      for (final exception in exceptions) {
        expect(
          exception.toString(),
          contains('core : unknown_core_exception_message_key'),
        );
      }
    });

    test('preserves inner details on toString', () {
      expect(
        const NoNetworkException(
          innerMessage: 'offline',
          innerError: 'socket',
        ).toString(),
        'core : no_network_exception_message_key (offline | socket)',
      );
    });
  });
}
