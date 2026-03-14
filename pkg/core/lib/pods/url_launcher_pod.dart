import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

part 'url_launcher_pod.g.dart';

enum UrlLaunchMode {
  /// Loads the URL in an in-app web view (e.g., Android WebView).
  inAppWebView,

  /// Loads the URL in an in-app web view (e.g., Android Custom Tabs, SFSafariViewController).
  inAppBrowserView,

  /// Passes the URL to the OS to be handled by another application.
  externalApplication,

  /// Passes the URL to the OS to be handled by another non-browser application.
  externalNonBrowserApplication
  ;

  const UrlLaunchMode();

  url_launcher.LaunchMode toUrlLauncherLaunchMode() {
    return switch (this) {
      inAppWebView => url_launcher.LaunchMode.inAppWebView,
      inAppBrowserView => url_launcher.LaunchMode.inAppBrowserView,
      externalApplication => url_launcher.LaunchMode.externalApplication,
      externalNonBrowserApplication =>
        url_launcher.LaunchMode.externalNonBrowserApplication,
    };
  }
}

@riverpod
UrlLauncher urlLauncher(Ref ref) => const UrlLauncher();

class UrlLauncher {
  const UrlLauncher();

  Future<Option<CoreException>> call({
    required String urlString,
    UrlLaunchMode mode = UrlLaunchMode.externalApplication,
    url_launcher.WebViewConfiguration webViewConfiguration =
        const url_launcher.WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    final url = Uri.tryParse(urlString);

    if (url == null) {
      return some(
        LaunchUrlException(innerMessage: 'Url parsing of: $urlString failed'),
      );
    }

    try {
      if (!await url_launcher.launchUrl(
        url,
        mode: mode.toUrlLauncherLaunchMode(),
        webViewConfiguration: webViewConfiguration,
        webOnlyWindowName: webOnlyWindowName,
      )) {
        return some(LaunchUrlException(innerMessage: 'Could not launch $url'));
      }
      return none();
    } on PlatformException catch (e, st) {
      // e.g. PlatformException from url_launcher_ios when SFSafariViewController
      // fails to load (e.g. App Store URLs), or other platform errors
      final message = e.message ?? 'Could not launch $url';
      return some(
        LaunchUrlException(
          innerError: e,
          innerMessage: message,
          st: st,
        ),
      );
    }
  }
}
