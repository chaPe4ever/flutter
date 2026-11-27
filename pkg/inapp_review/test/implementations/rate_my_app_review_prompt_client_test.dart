import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inapp_review/implementations/rate_my_app_review_prompt_client.dart';
import 'package:rate_my_app/rate_my_app.dart';

class _FakeRateMyApp extends RateMyApp {
  new() : super.customConditions(conditions: const []);

  bool? supported = true;
  int launchNativeCalls = 0;
  int launchStoreCalls = 0;

  @override
  Future<bool?> get isNativeReviewDialogSupported async => supported;

  @override
  Future<void> launchNativeReviewDialog() async {
    launchNativeCalls++;
  }

  @override
  Future<LaunchStoreResult> launchStore() async {
    launchStoreCalls++;
    return LaunchStoreResult.storeOpened;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeRateMyApp rateMyApp;
  late List<({String? appStoreId, String? googlePlayId})> creations;
  late RateMyAppReviewPromptClient client;

  setUp(() {
    rateMyApp = _FakeRateMyApp();
    creations = [];
    client = RateMyAppReviewPromptClient(
      appStoreIdentifier: 'app-store-default',
      googlePlayIdentifier: 'play-default',
      createRateMyApp: ({appStoreId, googlePlayId}) {
        creations.add((appStoreId: appStoreId, googlePlayId: googlePlayId));
        return rateMyApp;
      },
    );
  });

  test(
    'isAvailable returns true when the native dialog is supported',
    () async {
      rateMyApp.supported = true;

      await expectLater(client.isAvailable(), completion(isTrue));
      expect(creations, [
        (appStoreId: 'app-store-default', googlePlayId: 'play-default'),
      ]);
    },
  );

  test('isAvailable returns false when support is null', () async {
    rateMyApp.supported = null;

    await expectLater(client.isAvailable(), completion(isFalse));
  });

  test('requestReview launches the native review dialog', () async {
    await client.requestReview();

    expect(rateMyApp.launchNativeCalls, 1);
  });

  test('openStoreListing launches the store with overrides', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await client.openStoreListing(
      appStoreId: 'app-override',
      googlePlayId: 'play-override',
    );

    expect(creations, [
      (appStoreId: 'app-override', googlePlayId: 'play-override'),
    ]);
    expect(rateMyApp.launchStoreCalls, 1);
  });

  test('openStoreListing is a no-op on windows', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await client.openStoreListing();

    expect(creations, isEmpty);
    expect(rateMyApp.launchStoreCalls, 0);
  });

  test('default factory uses the rate_my_app method channel', () async {
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('rate_my_app'), (
          call,
        ) async {
          calls.add(call);
          if (call.method == 'isNativeDialogSupported') {
            return true;
          }
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('rate_my_app'), null);
    });

    const defaultClient = RateMyAppReviewPromptClient(
      appStoreIdentifier: 'store',
      googlePlayIdentifier: 'play',
    );

    await expectLater(defaultClient.isAvailable(), completion(isTrue));
    expect(calls.map((c) => c.method), ['isNativeDialogSupported']);
  });
}
