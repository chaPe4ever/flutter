import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LocalizationConfig.init', () {
    test('completes EasyLocalization initialisation', () async {
      await expectLater(LocalizationConfig().init(), completes);
    });
  });
}
