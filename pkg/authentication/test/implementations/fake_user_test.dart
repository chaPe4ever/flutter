import 'package:authentication/implementations/fake_auth_facade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeUser buildUser({bool emailVerified = true}) => FakeUser(
    metadata: UserMetadata(0, 0),
    uid: 'uid',
    email: 'user@example.com',
    displayName: 'User',
    photoURL: 'https://example.com/a.png',
    phoneNumber: '123',
    emailVerified: emailVerified,
  );

  group('FakeUser', () {
    test('supports no-op profile and verification helpers', () async {
      final user = buildUser();

      await user.delete();
      await user.reload();
      await user.sendEmailVerification();
      await user.updatePassword('secret12');
      await user.updateProfile(
        displayName: 'New',
        photoURL: 'https://x.dev/a.png',
      );

      expect(await user.getIdToken(), isNotEmpty);
      expect(user.providerData, isEmpty);
    });

    test('throws for unimplemented firebase user APIs', () async {
      final user = buildUser();
      final credential = EmailAuthProvider.credential(
        email: 'user@example.com',
        password: 'secret12',
      );

      await expectLater(
        () => user.reauthenticateWithCredential(credential),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.linkWithCredential(credential),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.linkWithPhoneNumber('+10000000000'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.linkWithPopup(GoogleAuthProvider()),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.linkWithProvider(GoogleAuthProvider()),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.linkWithRedirect(GoogleAuthProvider()),
        throwsA(isA<UnimplementedError>()),
      );
      expect(() => user.multiFactor, throwsA(isA<UnimplementedError>()));
      expect(
        () => user.reauthenticateWithPopup(GoogleAuthProvider()),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.reauthenticateWithProvider(GoogleAuthProvider()),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.reauthenticateWithRedirect(GoogleAuthProvider()),
        throwsA(isA<UnimplementedError>()),
      );
      expect(() => user.refreshToken, throwsA(isA<UnimplementedError>()));
      expect(
        () => user.updateDisplayName('name'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.updatePhoneNumber(
          PhoneAuthProvider.credential(
            verificationId: 'vid',
            smsCode: '123456',
          ),
        ),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.updatePhotoURL('https://example.com/a.png'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.verifyBeforeUpdateEmail('new@example.com'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => user.unlink(GoogleAuthProvider.PROVIDER_ID),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        user.getIdTokenResult,
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
