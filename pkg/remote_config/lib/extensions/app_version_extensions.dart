import 'package:remote_config/models/app_version_model.dart';

extension AppVersionModelX on AppVersionModel {
  bool checkIfUpdateIsAvailable(AppVersionModel other) {
    final curr = splitVersion;
    final upd = other.splitVersion;

    if (curr.length != upd.length || curr.length != 3) return false;

    for (var i = 0; i < curr.length; i++) {
      // Ignore any environment suffix at the end of version
      final currSegment = int.tryParse(curr[i].split('-').first) ?? 0;
      final updSegment = int.tryParse(upd[i]) ?? 0;

      if (currSegment < updSegment) return true;
      if (updSegment < currSegment) return false;
    }

    return buildNumber < other.buildNumber;
  }

  List<String> get splitVersion => version.split('.');

  String get toStringFormat => '$version ($buildNumber)';
}
