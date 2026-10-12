import 'package:core/core.dart';
import 'package:crashlytics/implementations/sentry_crashlytics_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sentryReport', () {
    test('reports a core exception inner error with its stack', () {
      final inner = StateError('no space');
      final stack = StackTrace.current;
      final wrapped = UnknownCoreException(innerError: inner, st: stack);

      final report = sentryReport(wrapped, StackTrace.empty);

      expect(report.throwable, same(inner));
      expect(report.stackTrace, same(stack));
    });

    test('keeps the platform stack when the wrapper has none', () {
      final inner = StateError('no space');
      final stack = StackTrace.current;
      final wrapped = UnknownCoreException(innerError: inner);

      final report = sentryReport(wrapped, stack);

      expect(report.throwable, same(inner));
      expect(report.stackTrace, same(stack));
    });

    test('reports the original error when there is no inner error', () {
      final error = StateError('plain');
      final stack = StackTrace.current;

      final report = sentryReport(error, stack);

      expect(report.throwable, same(error));
      expect(report.stackTrace, same(stack));
    });

    test('reports a core exception that has only a message key', () {
      final wrapped = UnknownCoreException();
      final stack = StackTrace.current;

      final report = sentryReport(wrapped, stack);

      expect(report.throwable, same(wrapped));
      expect(report.stackTrace, same(stack));
    });
  });
}
