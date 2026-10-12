import 'package:core/logger/logger_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

void main() {
  group('LoggerImpl', () {
    late List<OutputEvent> events;
    late LoggerImpl loggerImpl;

    setUp(() {
      events = [];
      loggerImpl = LoggerImpl(
        logger: Logger(
          output: _CollectingOutput(events),
          printer: SimplePrinter(),
        ),
      );
    });

    test('forwards debug messages to the underlying logger', () {
      loggerImpl.d('debug-msg');

      expect(events, isNotEmpty);
      expect(events.last.lines.join('\n'), contains('debug-msg'));
    });

    test('forwards error messages to the underlying logger', () {
      loggerImpl.e('error-msg', e: StateError('boom'));

      expect(events, isNotEmpty);
      expect(events.last.lines.join('\n'), contains('error-msg'));
    });

    test('forwards trace and warning levels', () {
      loggerImpl
        ..t('trace-msg')
        ..w('warn-msg');

      expect(events.length, greaterThanOrEqualTo(2));
    });

    test('forwards info without explicit stack trace', () {
      loggerImpl.i('info-msg');

      expect(events, isNotEmpty);
      expect(events.last.lines.join('\n'), contains('info-msg'));
    });
  });
}

final class _CollectingOutput extends LogOutput {
  _CollectingOutput(this.events);

  final List<OutputEvent> events;

  @override
  void output(OutputEvent event) {
    events.add(event);
  }
}
