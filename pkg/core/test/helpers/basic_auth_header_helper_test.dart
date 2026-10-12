import 'dart:convert';

import 'package:core/helpers/basic_auth_header_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('basicAuthHeader', () {
    test('encodes client id and secret as Basic auth', () {
      final header = basicAuthHeader(
        clientId: 'user',
        clientSecret: 'pass',
      );
      expect(header, startsWith('Basic '));
      final decoded = utf8.decode(
        base64Decode(header.substring('Basic '.length)),
      );
      expect(decoded, 'user:pass');
    });

    test('preserves characters Uri.encodeFull leaves unescaped', () {
      final header = basicAuthHeader(
        clientId: 'a@b',
        clientSecret: 'c/d',
      );
      final decoded = utf8.decode(
        base64Decode(header.substring('Basic '.length)),
      );
      expect(decoded, 'a@b:c/d');
    });
  });
}
