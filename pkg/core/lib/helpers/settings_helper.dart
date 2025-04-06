import 'package:core/storage/local_storage_base.dart';

/// Settings helper
final class SettingsHelper {
  /// Check if the settings hasn't been initialised with the default values
  /// and initialise them if needed
  static Future<void> init({
    required LocalStorageBase storage,
    Map<String, dynamic>? settingExtras,
  }) async {
    final settingsMap = {...?settingExtras};
    await Future.forEach(settingsMap.keys, (key) async {
      final value = settingsMap[key];
      if (await storage.read<dynamic>(key) == null) {
        await storage.write(key, value);
      }
    });
  }
}
