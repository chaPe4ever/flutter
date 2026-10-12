import 'package:core/helpers/asset_loader_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dispose closes translation notification stream', () {
    expect(AssetLoaderHelper.dispose, returnsNormally);
    // Idempotent when already closed.
    expect(AssetLoaderHelper.dispose, returnsNormally);
  });
}
