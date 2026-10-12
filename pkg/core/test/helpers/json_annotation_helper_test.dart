import 'package:core/helpers/json_annotation_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nullCb always returns null', () {
    expect(nullCb(null), isNull);
    expect(nullCb('anything'), isNull);
  });
}
