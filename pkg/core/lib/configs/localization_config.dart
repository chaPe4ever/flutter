import 'package:core/core.dart';

class LocalizationConfig implements Config {
  @override
  Future<void> init() async {
    await EasyLocalization.ensureInitialized();
  }
}
