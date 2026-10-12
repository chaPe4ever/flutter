import 'dart:isolate';

/// Registers a callback for uncaught errors in the current isolate.
typedef IsolateErrorListenerRegistrar =
    void Function(
      void Function(List<dynamic> pair) handler,
    );

/// Wires [handler] through a [RawReceivePort] on [Isolate.current].
void registerDefaultIsolateErrorListener(
  void Function(List<dynamic> pair) handler,
) {
  Isolate.current.addErrorListener(
    RawReceivePort(handler).sendPort,
  );
}
