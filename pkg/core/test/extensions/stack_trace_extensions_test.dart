import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StackTraceX', () {
    test('exposes parsed stack metadata', () {
      expect(StackTraceX.functionName, isNotEmpty);
      expect(StackTraceX.callerFunctionName, isNotEmpty);
      expect(StackTraceX.fileName, isNotEmpty);
      expect(StackTraceX.lineNumber, isNotEmpty);
      expect(StackTraceX.columnNumber, isNotEmpty);
    });
  });
}
