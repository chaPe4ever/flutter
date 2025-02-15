import 'dart:convert';

String basicAuthHeader({
  required String clientId,
  required String clientSecret,
}) {
  final basicUserPass =
      '${Uri.encodeFull(clientId)}:${Uri.encodeFull(clientSecret)}';
  return 'Basic ${base64Encode(ascii.encode(basicUserPass))}';
}
