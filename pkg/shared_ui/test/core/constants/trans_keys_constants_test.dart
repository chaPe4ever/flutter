import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/constants/trans_keys_constants.dart';

void main() {
  test('TransKeys exposes generated translation keys', () {
    expect(TransKeys.retry, 'retry');
    expect(TransKeys.more, 'more');
    expect(TransKeys.less, 'less');
    expect(TransKeys.signIn, 'sign_in');
  });
}
