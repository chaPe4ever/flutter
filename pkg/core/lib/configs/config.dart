/// Config interface
abstract interface class Config {
  /// initialisation method of any config derivative
  Future<void> init();
}
