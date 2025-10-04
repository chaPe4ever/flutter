import 'package:core/core.dart';

class LocalizationConfig implements ConfigBase {
  @override
  Future<void> init() async {
    await EasyLocalization.ensureInitialized();
  }
}
