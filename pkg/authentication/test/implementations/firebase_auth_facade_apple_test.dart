import 'package:authentication/exceptions/auth_exceptions.dart';
import 'package:authentication/implementations/firebase_auth_facade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/auth_dartz.dart';
import '../helpers/auth_mocks.dart';
import '../helpers/fake_logger.dart';

const _appleChannel = MethodChannel(
  'com.aboutyou.dart_packages.sign_in_with_apple',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(registerAuthFallbacks);

  late MockFirebaseAuth firebaseAuth;
  late MockUser user;
  late MockUserCredential userCredential;
  late FakeLogger logger;
  late FirebaseAuthFacade facade;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    user = MockUser();
    userCredential = MockUserCredential();
    logger = FakeLogger();
    facade = FirebaseAuthFacade(
      firebaseAuth: firebaseAuth,
      loggerBase: logger,
    );

    when(() => user.uid).thenReturn('apple-uid');
    when(() => user.email).thenReturn('user@example.com');
    when(() => user.displayName).thenReturn(null);
    when(() => user.emailVerified).thenReturn(true);
    when(() => user.reload()).thenAnswer((_) async {});
    when(() => user.updateDisplayName(any())).thenAnswer((_) async {});

    when(() => userCredential.user).thenReturn(user);
    when(() => userCredential.additionalUserInfo).thenReturn(null);

    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(
      () => firebaseAuth.signInWithCredential(any()),
    ).thenAnswer((_) async => userCredential);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_appleChannel, null);
  });

  group('signInWithApple', () {
    test('returns the current user for a first-time apple sign-in', () async {
      final additional = MockAdditionalUserInfo();
      when(() => additional.isNewUser).thenReturn(true);
      when(() => userCredential.additionalUserInfo).thenReturn(additional);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_appleChannel, (call) async {
            if (call.method == 'performAuthorizationRequest') {
              return {
                'type': 'appleid',
                'authorizationCode': 'auth-code',
                'identityToken': 'identity-token',
                'userIdentifier': 'apple-user',
                'givenName': 'Jane',
                'familyName': 'Doe',
                'email': 'jane@privaterelay.appleid.com',
              };
            }
            return null;
          });

      final result = await facade.signInWithApple();

      expect(result, authRight(user));
      verify(() => user.updateDisplayName('Jane Doe')).called(1);
    });

    test(
      'returns AuthServerErrorException when identityToken is missing',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(_appleChannel, (call) async {
              if (call.method == 'performAuthorizationRequest') {
                return {
                  'type': 'appleid',
                  'authorizationCode': 'auth-code',
                  'identityToken': '',
                };
              }
              return null;
            });

        final result = await facade.signInWithApple();

        expect(result, authLeft<User?>(const AuthServerErrorException()));
      },
    );

    test('maps user cancellation to AuthCanceledByUserException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_appleChannel, (call) async {
            throw PlatformException(
              code: 'authorization-error/canceled',
              message: 'The user canceled the authorization',
            );
          });

      final result = await facade.signInWithApple();

      expect(result, authLeft<User?>(const AuthCanceledByUserException()));
    });

    test(
      'maps unknown apple authorization errors to AuthCanceledByUserException',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(_appleChannel, (call) async {
              throw PlatformException(
                code: 'authorization-error/unknown',
                message: 'unknown',
              );
            });

        final result = await facade.signInWithApple();

        expect(result, authLeft<User?>(const AuthCanceledByUserException()));
      },
    );

    test('returns null for returning apple users', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_appleChannel, (call) async {
            if (call.method == 'performAuthorizationRequest') {
              return {
                'type': 'appleid',
                'authorizationCode': 'auth-code',
                'identityToken': 'identity-token',
              };
            }
            return null;
          });

      final result = await facade.signInWithApple();

      expect(result, authRight<User?>(null));
    });

    test('skips display name updates when firebase already has one', () async {
      when(() => user.displayName).thenReturn('Existing Name');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_appleChannel, (call) async {
            if (call.method == 'performAuthorizationRequest') {
              return {
                'type': 'appleid',
                'authorizationCode': 'auth-code',
                'identityToken': 'identity-token',
                'givenName': 'Jane',
                'familyName': 'Doe',
              };
            }
            return null;
          });

      final result = await facade.signInWithApple();

      expect(result, authRight<User?>(null));
      verifyNever(() => user.updateDisplayName(any()));
    });

    test('maps other apple errors to AuthServerErrorException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_appleChannel, (call) async {
            throw PlatformException(
              code: 'authorization-error/failed',
              message: 'failed',
            );
          });

      final result = await facade.signInWithApple();

      expect(result, authLeft<User?>(const AuthServerErrorException()));
    });

    test('maps firebase cancellation to AuthCanceledByUserException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_appleChannel, (call) async {
            if (call.method == 'performAuthorizationRequest') {
              return {
                'type': 'appleid',
                'authorizationCode': 'auth-code',
                'identityToken': 'identity-token',
              };
            }
            return null;
          });
      when(() => firebaseAuth.signInWithCredential(any())).thenThrow(
        FirebaseAuthException(code: 'user-cancelled'),
      );

      final result = await facade.signInWithApple();

      expect(result, authLeft<User?>(const AuthCanceledByUserException()));
    });

    test('maps other firebase errors to AuthServerErrorException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_appleChannel, (call) async {
            if (call.method == 'performAuthorizationRequest') {
              return {
                'type': 'appleid',
                'authorizationCode': 'auth-code',
                'identityToken': 'identity-token',
              };
            }
            return null;
          });
      when(() => firebaseAuth.signInWithCredential(any())).thenThrow(
        FirebaseAuthException(code: 'network-request-failed'),
      );

      final result = await facade.signInWithApple();

      expect(result, authLeft<User?>(const AuthServerErrorException()));
    });
  });
}
