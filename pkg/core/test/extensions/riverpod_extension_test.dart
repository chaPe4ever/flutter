import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _errorStepProvider =
    NotifierProvider<_ErrorStepNotifier, AsyncValue<void>>(
      _ErrorStepNotifier.new,
    );

class _ErrorStepNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.loading();

  void fail(Object error) {
    state = AsyncValue.error(error, StackTrace.current);
  }
}

void main() {
  test('Ref.cache returns callback value', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final provider = Provider.autoDispose<int>((ref) {
      return ref.cache(
        () => 42,
        duration: const Duration(seconds: 5),
      );
    });

    expect(container.read(provider), 42);
  });

  test('Ref.cacheCountdown returns callback value', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final provider = Provider.autoDispose<String>((ref) {
      return ref.cacheCountdown(
        () => 'cached',
        duration: const Duration(seconds: 5),
      );
    });

    expect(container.read(provider), 'cached');
  });

  test('Ref.cache lifecycle callbacks run on listen changes', () async {
    var onDisposeCalls = 0;
    var onCancelCalls = 0;
    var onResumeCalls = 0;

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final provider = Provider.autoDispose<int>((ref) {
      return ref.cache(
        () => 1,
        duration: const Duration(milliseconds: 50),
        onDispose: () => onDisposeCalls++,
        onCancel: () => onCancelCalls++,
        onResume: () => onResumeCalls++,
      );
    });

    final sub = container.listen(provider, (_, _) {});
    expect(container.read(provider), 1);
    sub.close();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    container.listen(provider, (_, _) {});
    expect(onCancelCalls, greaterThanOrEqualTo(1));
    expect(onResumeCalls, greaterThanOrEqualTo(1));
    container.dispose();
    expect(onDisposeCalls, greaterThanOrEqualTo(1));
  });

  test('Ref.cacheCountdown lifecycle callbacks run', () async {
    var onDisposeCalls = 0;
    var onCancelCalls = 0;
    var onResumeCalls = 0;

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final provider = Provider.autoDispose<int>((ref) {
      return ref.cacheCountdown(
        () => 2,
        duration: const Duration(milliseconds: 50),
        onDispose: () => onDisposeCalls++,
        onCancel: () => onCancelCalls++,
        onResume: () => onResumeCalls++,
      );
    });

    final sub = container.listen(provider, (_, _) {});
    expect(container.read(provider), 2);
    sub.close();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    container.listen(provider, (_, _) {});
    expect(onCancelCalls, greaterThanOrEqualTo(1));
    expect(onResumeCalls, greaterThanOrEqualTo(1));
    container.dispose();
    expect(onDisposeCalls, greaterThanOrEqualTo(1));
  });

  testWidgets('listenForError invokes onError for AsyncError', (tester) async {
    CoreException? captured;
    const failure = NoNetworkException();

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            ref.listenForError(
              _errorStepProvider,
              onError: (e) async {
                captured = e;
              },
            );
            return const SizedBox(key: Key('probe'));
          },
        ),
      ),
    );
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byKey(const Key('probe'))),
    );
    container.read(_errorStepProvider.notifier).fail(failure);
    await tester.pump();

    expect(captured, same(failure));
  });
}
