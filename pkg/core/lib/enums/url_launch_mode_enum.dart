import 'package:core/core.dart' show LaunchMode;

enum UrlLaunchModeEnum {
  /// Loads the URL in an in-app web view (e.g., Android WebView).
  inAppWebView,

  /// Loads the URL in an in-app web view (e.g., Android Custom Tabs, SFSafariViewController).
  inAppBrowserView,

  /// Passes the URL to the OS to be handled by another application.
  externalApplication,

  /// Passes the URL to the OS to be handled by another non-browser application.
  externalNonBrowserApplication
  ;

  const UrlLaunchModeEnum();

  LaunchMode toDomainMode() {
    return switch (this) {
      inAppWebView => LaunchMode.inAppWebView,
      inAppBrowserView => LaunchMode.inAppBrowserView,
      externalApplication => LaunchMode.externalApplication,
      externalNonBrowserApplication => LaunchMode.externalNonBrowserApplication,
    };
  }
}
