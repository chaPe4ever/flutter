import 'package:core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

part 'url_launcher_pod.g.dart';

@riverpod
UrlLauncher urlLauncher(Ref ref) => const UrlLauncher();

class UrlLauncher {
  const UrlLauncher();

  Future<Option<CoreException>> call({
    required String urlString,
    url_launcher.LaunchMode mode = url_launcher.LaunchMode.platformDefault,
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

    if (!await url_launcher.launchUrl(
      url,
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    )) {
      return some(LaunchUrlException(innerMessage: 'Could not launch $url'));
    }
    return none();
  }
}
