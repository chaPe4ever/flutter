import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications/implementations/local_notifications_impl.dart';
import 'package:local_notifications/pods/local_notification_pod.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class _MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class _MockIosFlutterLocalNotificationsPlugin extends Mock
    implements IOSFlutterLocalNotificationsPlugin {}

class _MockMacOsFlutterLocalNotificationsPlugin extends Mock
    implements MacOSFlutterLocalNotificationsPlugin {}

void main() {
  late _MockFlutterLocalNotificationsPlugin mockPlugin;
  late LocalNotificationsImpl impl;

  setUpAll(() {
    registerFallbackValue(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    registerFallbackValue(
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel',
          'name',
        ),
      ),
    );
  });

  setUp(() {
    mockPlugin = _MockFlutterLocalNotificationsPlugin();
    impl = LocalNotificationsImpl(notifications: mockPlugin);
  });

  tearDown(() {
    impl.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  group('dispose', () {
    test('closes stream controllers and ignores repeated dispose', () {
      impl.dispose();
      expect(impl.fgNotificationController?.isClosed, isTrue);
      expect(impl.bgNotificationController?.isClosed, isTrue);

      expect(() => impl.dispose(), returnsNormally);
    });
  });

  group('init', () {
    test(
      'initializes without response handlers on supported platforms',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        final android = _MockAndroidFlutterLocalNotificationsPlugin();
        when(
          () => mockPlugin.initialize(settings: any(named: 'settings')),
        ).thenAnswer((_) async => true);
        when(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(android);
        when(
          android.requestNotificationsPermission,
        ).thenAnswer((_) async => true);

        await impl.init();

        verify(
          () => mockPlugin.initialize(settings: any(named: 'settings')),
        ).called(1);
        verify(android.requestNotificationsPermission).called(1);
      },
    );

    test('initializes with response handlers when both are provided', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final ios = _MockIosFlutterLocalNotificationsPlugin();
      when(
        () => mockPlugin.initialize(
          settings: any(named: 'settings'),
          onDidReceiveBackgroundNotificationResponse: any(
            named: 'onDidReceiveBackgroundNotificationResponse',
          ),
          onDidReceiveNotificationResponse: any(
            named: 'onDidReceiveNotificationResponse',
          ),
        ),
      ).thenAnswer((_) async => true);
      when(
        () => mockPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >(),
      ).thenReturn(ios);
      when(
        () => ios.requestPermissions(alert: true, badge: true, sound: true),
      ).thenAnswer((_) async => true);

      await impl.init(
        onDidReceiveBackgroundNotificationResponse: (_) {},
        onDidReceiveNotificationResponse: (_) {},
      );

      verify(
        () => mockPlugin.initialize(
          settings: any(named: 'settings'),
          onDidReceiveBackgroundNotificationResponse: any(
            named: 'onDidReceiveBackgroundNotificationResponse',
          ),
          onDidReceiveNotificationResponse: any(
            named: 'onDidReceiveNotificationResponse',
          ),
        ),
      ).called(1);
      verify(
        () => ios.requestPermissions(alert: true, badge: true, sound: true),
      ).called(1);
    });

    test('requests macOS permissions', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      final macos = _MockMacOsFlutterLocalNotificationsPlugin();
      when(
        () => mockPlugin.initialize(settings: any(named: 'settings')),
      ).thenAnswer((_) async => true);
      when(
        () => mockPlugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >(),
      ).thenReturn(macos);
      when(
        () => macos.requestPermissions(alert: true, badge: true, sound: true),
      ).thenAnswer((_) async => true);

      await impl.init();

      verify(
        () => macos.requestPermissions(alert: true, badge: true, sound: true),
      ).called(1);
    });

    test('throws when the platform is not supported', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      when(
        () => mockPlugin.initialize(settings: any(named: 'settings')),
      ).thenAnswer((_) async => true);

      await expectLater(impl.init(), throwsA(isA<UnimplementedError>()));
    });

    test('asserts when only one response handler is provided', () async {
      expect(
        () => impl.init(onDidReceiveNotificationResponse: (_) {}),
        throwsAssertionError,
      );
    });
  });

  group('showNotification', () {
    int? lastId;
    String? lastPayload;
    NotificationDetails? lastDetails;

    setUp(() {
      lastId = null;
      lastPayload = null;
      lastDetails = null;
      when(
        () => mockPlugin.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((invocation) async {
        lastId = invocation.namedArguments[#id] as int?;
        lastPayload = invocation.namedArguments[#payload] as String?;
        lastDetails =
            invocation.namedArguments[#notificationDetails]
                as NotificationDetails?;
      });
    });

    test('shows a notification with defaults', () async {
      await impl.showNotification(title: 'Hi', body: 'There');

      expect(lastId, 0);
      expect(lastPayload, isNull);
      expect(lastDetails?.android?.channelId, 'high_importance_channel');
    });

    test('shows a notification with sound, actions, and overrides', () async {
      await impl.showNotification(
        id: 3,
        title: 'Title',
        body: 'Body',
        payload: 'data',
        channelId: 'custom',
        sound: 'alert',
        badgeNumber: 2,
        gorupKey: 'group-a',
        actions: [
          const AndroidNotificationActionAdapter(
            id: 'act',
            title: 'Act',
            titleColor: Color(0xFF000000),
          ),
        ],
      );

      expect(lastId, 3);
      expect(lastPayload, 'data');
      expect(lastDetails?.android?.channelId, 'custom');
      expect(lastDetails?.android?.groupKey, 'group-a');
      expect(
        lastDetails?.android?.sound,
        isA<RawResourceAndroidNotificationSound>(),
      );
      expect(lastDetails?.android?.actions, hasLength(1));
      expect(lastDetails?.iOS?.badgeNumber, 2);
      expect(lastDetails?.iOS?.threadIdentifier, 'custom');
      expect(lastDetails?.macOS?.categoryIdentifier, 'group-a');
    });
  });

  group('cancel', () {
    test('cancelNotification forwards the id', () async {
      when(
        () => mockPlugin.cancel(id: any(named: 'id')),
      ).thenAnswer((_) async {});

      await impl.cancelNotification(id: 9);

      verify(() => mockPlugin.cancel(id: 9)).called(1);
    });

    test('cancelAllNotifications clears all notifications', () async {
      when(mockPlugin.cancelAll).thenAnswer((_) async {});

      await impl.cancelAllNotifications();

      verify(mockPlugin.cancelAll).called(1);
    });
  });

  group('messageHanlder', () {
    test('forwards foreground and background messages', () async {
      NotificationResponse? fg;
      NotificationResponse? bg;

      await impl.messageHanlder(
        onFgMessage: (message) => fg = message,
        onBgMessage: (message) => bg = message,
      );

      const fgMessage = NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        id: 1,
      );
      const bgMessage = NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        id: 2,
      );

      impl.fgNotificationController!.add(fgMessage);
      impl.bgNotificationController!.add(bgMessage);
      await pumpEventQueue();

      expect(fg, fgMessage);
      expect(bg, bgMessage);
    });

    test('returns immediately after dispose', () async {
      impl.dispose();

      await expectLater(impl.messageHanlder(), completes);
    });

    test('replaces existing subscriptions', () async {
      var fgCount = 0;
      await impl.messageHanlder(onFgMessage: (_) => fgCount++);
      await impl.messageHanlder(onFgMessage: (_) => fgCount++);

      impl.fgNotificationController!.add(
        const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
        ),
      );
      await pumpEventQueue();

      expect(fgCount, 1);
    });
  });
}
