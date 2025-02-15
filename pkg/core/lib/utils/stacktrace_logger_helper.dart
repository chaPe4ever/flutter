import 'package:core/core.dart';

/// Stack trace logger helper class
final class StackTraceLoggerHelper {
  const StackTraceLoggerHelper._({
    required this.functionName,
    required this.callerFunctionName,
    required this.fileName,
    required this.lineNumber,
    required this.columnNumber,
  });

  /// Get the logger helper model from a stacktrace
  factory StackTraceLoggerHelper.from(StackTrace trace) {
    final frames = trace.toString().split('\n');
    final functionName = getFunctionNameFromFrame(frames[0]);
    final callerFunctionName = getFunctionNameFromFrame(frames[1]);
    final fileInfo = getFileInfoFromFrame(frames[0]);

    return StackTraceLoggerHelper._(
      functionName: functionName,
      callerFunctionName: callerFunctionName,
      fileName: fileInfo[0],
      lineNumber: int.parse(fileInfo[1]),
      columnNumber: int.parse(fileInfo[2].replaceFirst(')', '')),
    );
  }

  /// Get he logger helper model from a stacktrace or from current if [trace]
  /// is empty
  factory StackTraceLoggerHelper.st(StackTrace trace) {
    late StackTrace st;
    if (trace.toString().isEmpty) {
      st = StackTrace.current;
    } else {
      st = trace;
    }
    final frames = st.toString().split('\n');
    final functionName = getFunctionNameFromFrame(frames[0]);
    final callerFunctionName = getFunctionNameFromFrame(frames[1]);
    final fileInfo = getFileInfoFromFrame(frames[0]);

    return StackTraceLoggerHelper._(
      functionName: functionName,
      callerFunctionName: callerFunctionName,
      fileName: fileInfo[0],
      lineNumber: int.parse(fileInfo[1]),
      columnNumber: int.parse(fileInfo[2].replaceFirst(')', '')),
    );
  }

  /// self explained
  final String functionName;

  /// self explained
  final String callerFunctionName;

  /// self explained
  final String fileName;

  /// self explained
  final int lineNumber;

  /// self explained
  final int columnNumber;

  /// Should not be used in practice should be private
  @visibleForTesting
  static List<String> getFileInfoFromFrame(String trace) {
    final indexOfFileName = trace.indexOf(RegExp('[A-Za-z]+.dart'));
    final fileInfo = trace.substring(indexOfFileName);

    return fileInfo.split(':');
  }

  /// Should not be used in practice should be private
  @visibleForTesting
  static String getFunctionNameFromFrame(String trace) {
    final indexOfWhiteSpace = trace.indexOf(' ');
    final subStr = trace.substring(indexOfWhiteSpace);
    final indexOfFunction = subStr.indexOf(RegExp('[A-Za-z0-9]'));

    return subStr
        .substring(indexOfFunction)
        .substring(0, subStr.substring(indexOfFunction).indexOf(' '));
  }

  @override
  String toString() {
    return 'LoggerStackTrace('
        'functionName: $functionName, '
        'callerFunctionName: $callerFunctionName, '
        'fileName: $fileName, '
        'lineNumber: $lineNumber, '
        'columnNumber: $columnNumber)';
  }
}
