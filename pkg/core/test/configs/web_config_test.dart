import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WebConfig.init', () {
    test('enables imperative API URL reflection on GoRouter', () async {
      addTearDown(() {
        GoRouter.optionURLReflectsImperativeAPIs = false;
      });

      await WebConfig().init();

      expect(GoRouter.optionURLReflectsImperativeAPIs, isTrue);
    });

    test('configureWebFlutterErrorHandling logs when web and not release', () {
      final logged = <String>[];
      configureWebFlutterErrorHandling(
        isWeb: true,
        logError: (message, {StackTrace? st}) => logged.add(message),
      );

      FlutterError.onError?.call(
        FlutterErrorDetails(exception: Exception('web-fail')),
      );

      expect(logged, contains('Exception: web-fail'));
    });
  });
}
