import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    Logs.disable(Logs.values);
  });

  group('Logs', () {
    test('enable and disable toggles individual channels', () {
      expect(Logs.api.enabled, isFalse);

      Logs.enable([Logs.api]);
      expect(Logs.api.enabled, isTrue);

      Logs.disable([Logs.api]);
      expect(Logs.api.enabled, isFalse);
    });

    test('enable updates multiple channels', () {
      Logs.enable([Logs.api, Logs.riverpod]);

      expect(Logs.api.enabled, isTrue);
      expect(Logs.riverpod.enabled, isTrue);
      expect(Logs.error.enabled, isFalse);
    });
  });

  group('Log', () {
    test('does not throw when channels are disabled', () {
      Logs.disable(Logs.values);

      expect(() => Log.api('x'), returnsNormally);
      expect(() => Log.info('x'), returnsNormally);
      expect(() => Log.warning('x'), returnsNormally);
      expect(() => Log.analytics('x'), returnsNormally);
      expect(() => Log.push('x'), returnsNormally);
      expect(() => Log.error('x'), returnsNormally);
      expect(
        () => Log.riverpod(providerName: 'p', info: 'i'),
        returnsNormally,
      );
    });

    test('enabled error logs are visible on the debug console', () {
      final lines = <String>[];
      final previous = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        lines.add(message ?? '');
      };
      addTearDown(() => debugPrint = previous);

      Logs.enable([Logs.error]);
      Log.error('startup-boom', st: StackTrace.empty);

      expect(lines.any((line) => line.contains('startup-boom')), isTrue);
    });

    test('does not throw when channels are enabled', () {
      Logs.enable(Logs.values);

      expect(() => Log.api('x'), returnsNormally);
      expect(() => Log.info('x'), returnsNormally);
      expect(() => Log.warning('x'), returnsNormally);
      expect(() => Log.analytics('x'), returnsNormally);
      expect(() => Log.push('x'), returnsNormally);
      expect(() => Log.error('x', st: StackTrace.current), returnsNormally);
      expect(
        () => Log.riverpod(
          providerName: 'provider',
          info: 'info',
          error: StateError('e'),
          verboseCb: ({required bool isActive}) => isActive ? 'v' : 'verbose',
        ),
        returnsNormally,
      );
    });
  });

  group('SignalsLogger', () {
    test('log completes when signal channel is enabled', () {
      Logs.enable([Logs.signal]);
      final observer = SignalsLogger();

      expect(() => observer.log('signal-event'), returnsNormally);
    });
  });

  group('RiverpodLogger', () {
    test('didUpdateProvider runs when riverpod logging is enabled', () {
      Logs.enable([Logs.riverpod]);
      const observer = RiverpodLogger();
      final container = ProviderContainer(
        observers: [observer],
      );
      addTearDown(container.dispose);

      expect(container.read(_riverpodProbePod), 0);
      container.read(_riverpodProbePod.notifier).bump();
      expect(container.read(_riverpodProbePod), 1);
    });

    test('didUpdateProvider logs AsyncError values', () {
      Logs.enable([Logs.riverpod]);
      const observer = RiverpodLogger();
      final container = ProviderContainer(
        observers: [observer],
      );
      addTearDown(container.dispose);

      container
          .read(_riverpodErrorProbePod.notifier)
          .fail(
            const NoNetworkException(),
          );
      container
          .read(_riverpodErrorProbePod.notifier)
          .fail(
            const ClientVisibleException(messageKey: 'visible'),
          );
      container
          .read(_riverpodErrorProbePod.notifier)
          .fail(
            StateError('plain'),
          );
    });
  });

  group('Logs.enabled setter', () {
    test('toggles every log channel individually', () {
      for (final log in Logs.values) {
        log.enabled = true;
        expect(log.enabled, isTrue);
        log.enabled = false;
        expect(log.enabled, isFalse);
      }
    });
  });
}

final _riverpodErrorProbePod =
    NotifierProvider<_RiverpodErrorProbeNotifier, AsyncValue<void>>(
      _RiverpodErrorProbeNotifier.new,
    );

class _RiverpodErrorProbeNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  void fail(Object error) {
    state = AsyncValue.error(error, StackTrace.current);
  }
}

final _riverpodProbePod = NotifierProvider<_RiverpodProbeNotifier, int>(
  _RiverpodProbeNotifier.new,
);

class _RiverpodProbeNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state = state + 1;
}
