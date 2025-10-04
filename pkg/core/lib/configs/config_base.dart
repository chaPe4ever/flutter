/// Config interface
abstract interface class ConfigBase {
  /// initialisation method of any config derivative
  Future<void> init();
}
