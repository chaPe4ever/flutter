import 'package:core/core.dart';
import 'package:core/enums/url_launch_mode_enum.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

part 'url_launcher_pod.g.dart';

@riverpod
UrlLauncher urlLauncher(Ref ref) => const UrlLauncher();

class UrlLauncher {
  const UrlLauncher();

  Future<Option<CoreException>> call({
    required String urlString,
    UrlLaunchModeEnum mode = UrlLaunchModeEnum.externalApplication,
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
        mode: mode.toDomainMode(),
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
