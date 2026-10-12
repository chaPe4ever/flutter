import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UrlLaunchModeEnum.toDomainMode', () {
    test('maps every variant to the matching LaunchMode', () {
      expect(
        UrlLaunchModeEnum.inAppWebView.toDomainMode(),
        LaunchMode.inAppWebView,
      );
      expect(
        UrlLaunchModeEnum.inAppBrowserView.toDomainMode(),
        LaunchMode.inAppBrowserView,
      );
      expect(
        UrlLaunchModeEnum.externalApplication.toDomainMode(),
        LaunchMode.externalApplication,
      );
      expect(
        UrlLaunchModeEnum.externalNonBrowserApplication.toDomainMode(),
        LaunchMode.externalNonBrowserApplication,
      );
    });
  });
}
