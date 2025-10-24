## Eager Provider Initialization

- In Flutter applications using Riverpod for state management, providers are often initialized lazily, meaning they are created only when first accessed. However, in certain scenarios, eager initialization of providers can be beneficial for performance and user experience.
- Eager provider initialization involves creating and initializing providers as soon as the application starts, rather than waiting for them to be accessed. This can help reduce latency when the provider's data is needed, as the data is already available.
- To implement eager provider initialization in Riverpod, we will leverage a technique where we will use a startup provider at the initialisation of the app to eagerly initialize all required providers.

```dart
@Riverpod(keepAlive: true)
class startup extends _$startup {
  @override
  FutureOr<void> build() async {
    // Clean up resources or cancel any ongoing tasks
    ref.onDispose(() {
        // Invalidate eagerly initialized providers if necessary         
        ref.invalidate(settingsProvider);
    });

    // Eagerly initialize other providers here    
    await Future.wait([
        ref.read(settingsProvider.future),
        // Add more providers as needed
    ]);
  }
```

## Usage of the provider to a consumer widget

```dart
class StartupWidget extends ConsumerWidget {
  const StartupWidget({required this.onLoaded, super.key});

  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupState = ref.watch(startupProvider);
    return startupState.when(
      data: (_) => onLoaded(context),
      loading: () => const StartupLoadingWidget(),
      error: (e, st) => StartupErrorWidget(
        message: StartupException(
          innerError: e,
          st: st,
        ).messageKey.tr(),
        onRetry: () => ref.invalidate(startupProvider),
      ),
    );    
  }
}
```
