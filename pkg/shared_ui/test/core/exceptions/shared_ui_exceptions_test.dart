import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/exceptions/shared_ui_exceptions.dart';

void main() {
  group('SharedUiEx', () {
    test('uses shared_ui prefix by default', () {
      expect(
        const UnknownSharedUiException().toString(),
        contains('shared_ui'),
      );
    });

    test('subtypes preserve message key', () {
      expect(const NoteException().messageKey, 'hardcoded');
      expect(const PageNotFoundCoreException().messageKey, 'hardcoded');
      expect(const UnknownSharedUiException().messageKey, 'hardcoded');
    });

    test('subtypes are CoreException', () {
      expect(const NoteException(), isA<CoreException>());
      expect(const PageNotFoundCoreException(), isA<SharedUiEx>());
    });
  });
}
