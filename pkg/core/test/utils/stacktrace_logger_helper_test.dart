import 'package:core/utils/stacktrace_logger_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StackTraceLoggerHelper parsing helpers', () {
    test('getFileInfoFromFrame splits file line column', () {
      const frame = '#0      demo (file:///app/lib/demo.dart:12:34)';
      expect(
        StackTraceLoggerHelper.getFileInfoFromFrame(frame),
        ['demo.dart', '12', '34)'],
      );
    });

    test('getFunctionNameFromFrame extracts symbol', () {
      const frame = '#0      myFunction (file:///app/lib/demo.dart:1:1)';
      expect(
        StackTraceLoggerHelper.getFunctionNameFromFrame(frame),
        'myFunction',
      );
    });
  });
}
