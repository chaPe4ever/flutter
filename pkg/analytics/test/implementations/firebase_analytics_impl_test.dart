import 'package:analytics/exceptions/analytics_exceptions.dart';
import 'package:analytics/implementations/firebase_analytics_impl.dart';
import 'package:analytics/unions/analytics_event.dart';
import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_analytics_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseAnalytics>()])
void main() {
  group('FirebaseAnalyticsImpl', () {
    late MockFirebaseAnalytics firebaseAnalytics;
    late FirebaseAnalyticsImpl impl;

    setUp(() {
      resetMockitoState();
      firebaseAnalytics = MockFirebaseAnalytics();
      impl = FirebaseAnalyticsImpl(analytics: firebaseAnalytics);
    });

    group('logEvent', () {
      test('forwards firebase events to Firebase Analytics', () async {
        const parameters = {'source': 'test'};
        when(
          firebaseAnalytics.logEvent(
            name: 'custom_event',
            parameters: parameters,
          ),
        ).thenAnswer((_) async {});

        await impl.logEvent(
          analyticsEvent: FirebaseAnalyticsEvent(
            name: 'custom_event',
            parameters: parameters,
          ),
        );

        verify(
          firebaseAnalytics.logEvent(
            name: 'custom_event',
            parameters: parameters,
          ),
        ).called(1);
      });

      test('rethrows core exceptions unchanged', () async {
        final coreError = UnknownCoreException();
        when(
          firebaseAnalytics.logEvent(name: 'fail'),
        ).thenThrow(coreError);

        await expectLater(
          impl.logEvent(
            analyticsEvent: FirebaseAnalyticsEvent(name: 'fail'),
          ),
          throwsA(same(coreError)),
        );
      });

      test('wraps unexpected errors in UnknownAnalyticsException', () async {
        when(
          firebaseAnalytics.logEvent(name: 'fail'),
        ).thenThrow(Exception('channel down'));

        await expectLater(
          impl.logEvent(
            analyticsEvent: FirebaseAnalyticsEvent(name: 'fail'),
          ),
          throwsA(
            isA<UnknownAnalyticsException>().having(
              (e) => e.innerError,
              'innerError',
              isA<Exception>(),
            ),
          ),
        );
      });
    });

    group('setAnalytics', () {
      test('enables or disables collection on the delegate', () async {
        when(
          firebaseAnalytics.setAnalyticsCollectionEnabled(true),
        ).thenAnswer((_) async {});
        when(
          firebaseAnalytics.setAnalyticsCollectionEnabled(false),
        ).thenAnswer((_) async {});

        await impl.setAnalytics(enabled: true);
        await impl.setAnalytics(enabled: false);

        verify(
          firebaseAnalytics.setAnalyticsCollectionEnabled(true),
        ).called(1);
        verify(
          firebaseAnalytics.setAnalyticsCollectionEnabled(false),
        ).called(1);
      });

      test('wraps synchronous delegate failures', () {
        when(
          firebaseAnalytics.setAnalyticsCollectionEnabled(true),
        ).thenThrow(Exception('sync failure'));

        expect(
          () => impl.setAnalytics(enabled: true),
          throwsA(isA<UnknownAnalyticsException>()),
        );
      });
    });

    group('setCurrentScreen', () {
      test('logs a screen view with the provided name', () async {
        when(
          firebaseAnalytics.logScreenView(screenName: 'Settings'),
        ).thenAnswer((_) async {});

        await impl.setCurrentScreen(screenName: 'Settings');

        verify(
          firebaseAnalytics.logScreenView(screenName: 'Settings'),
        ).called(1);
      });

      test('wraps synchronous delegate failures', () {
        when(
          firebaseAnalytics.logScreenView(screenName: 'Broken'),
        ).thenThrow(Exception('sync failure'));

        expect(
          () => impl.setCurrentScreen(screenName: 'Broken'),
          throwsA(isA<UnknownAnalyticsException>()),
        );
      });
    });

    group('setUserId', () {
      test('forwards the user id to the delegate', () async {
        when(
          firebaseAnalytics.setUserId(id: 'user-42'),
        ).thenAnswer((_) async {});
        when(firebaseAnalytics.setUserId()).thenAnswer((_) async {});

        await impl.setUserId(id: 'user-42');
        await impl.setUserId();

        verify(firebaseAnalytics.setUserId(id: 'user-42')).called(1);
        verify(firebaseAnalytics.setUserId()).called(1);
      });

      test('wraps synchronous delegate failures', () {
        when(
          firebaseAnalytics.setUserId(id: 'user-42'),
        ).thenThrow(Exception('sync failure'));

        expect(
          () => impl.setUserId(id: 'user-42'),
          throwsA(isA<UnknownAnalyticsException>()),
        );
      });
    });
  });
}
