import 'package:core/configs/config.dart';

/// App config class
final class AppConfig implements Config {
  /// Constructor
  AppConfig({required this.configs});

  /// list of configs that the app needs to initialise
  final List<Config> configs;

  @override
  Future<void> init() async {
    await Future.forEach(configs, (config) => config.init());
  }
}
