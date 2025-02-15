import 'package:core/core.dart';
import 'package:remote_config/models/app_version_model.dart';

final class VersionHelper {
  static Future<AppVersionModel> appVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return AppVersionModel(
      version: packageInfo.version,
      buildNumber: int.tryParse(packageInfo.buildNumber) ?? 0,
    );
  }
}
