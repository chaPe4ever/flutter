// ignore_for_file: unnecessary_raw_strings

final _scriptTagRegExp = RegExp(r'<script.*?>.*?</script>', dotAll: true);
final _javascriptUrlRegExp = RegExp(r'javascript:[^\s]+');
final _htmlEventHandlersRegExp = RegExp(r'''on\w+=["']?.*?["']?''');
final _htmlTagsRegExp = RegExp(r'<.*?>', dotAll: true);

final List<RegExp> _xssRegExpList = [
  _scriptTagRegExp,
  _javascriptUrlRegExp,
  _htmlEventHandlersRegExp,
  _htmlTagsRegExp,
];

/// Check if the input is a XSS String
bool isXSS(String? input) {
  if (input == null || input.isEmpty) {
    return false;
  }
  return _xssRegExpList.any((e) => e.hasMatch(input));
}
