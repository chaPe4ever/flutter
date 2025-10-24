# Router (go_router_builder + Riverpod)

This file documents the project's routing conventions and patterns used with `go_router_builder` and Riverpod.

## Key ideas
- Routes are defined with the `@TypedGoRoute` annotation and extend `GoRouteData`. The codegen produces:
    - `$appRoutes` (list of `GoRoute`) to pass to `GoRouter`
    - helpers on each route class: `.location`, `.go(context)`, `.push(context)` (and similar)
- A singleton Riverpod provider constructs the `GoRouter`. The provider wires up redirects, refresh listeners, observers, navigator keys and error handling.

## Example typed route
```dart
@TypedGoRoute<StartupRoute>(path: '/startup')
class StartupRoute extends GoRouteData with _$StartupRoute {
    const StartupRoute();

    @override
    Widget build(BuildContext context, GoRouterState state) =>
            AppStartupWidget(onLoaded: (_) => const GameroomEmptyPage());
}
```
- Codegen will generate `const StartupRoute().location`, `const StartupRoute().go(context)`, and `const StartupRoute().push(context)`.

## GoRouter provider (Riverpod)
Example provider used in the project:
```dart
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
    return GoRouter(
        observers: [SentryNavigatorObserver()],
        navigatorKey: routerRootNavigatorKey,
        initialLocation: ref.read(authFacadePod).getSignedInUser().isNone()
                ? const WelcomeRoute().location
                : const HomeRoute().location,
        debugLogDiagnostics: kDebugMode,
        redirect: (context, state) async =>
                appStartupRedirect(appStartup: ref.read(appStartupPod)) ??
                await userAuthRedirect(
                    authFacade: ref.read(authFacadePod),
                    state: state,
                ),
        refreshListenable: GoRouterRefreshListenable([
            ref.watch(authFacadePod).authStateChangeStream(),
            ref.watch(appStartupStreamPod.stream),
        ]),
        routes: $appRoutes,
        errorBuilder: (_, __) => const NotFoundPage(),
    );
}
```
Notes:
- `routes: $appRoutes` is the generated route list.
- `initialLocation` can use generated `.location` values.
- `redirect` can return a `String?` or `Future<String?>`. It runs on navigation and can be composed (return first non-null).
- `refreshListenable` uses `GoRouterRefreshListenable` to convert streams/change notifiers into router refresh triggers (useful for auth/app startup).
- `navigatorKey` can be the root navigator key used by modals or overlays.
- `observers` are useful for analytics/sentry.

## Navigation usage
Preferred (generated helpers):
```dart
// Replace current history entry:
const StartupRoute().go(context);

// Push a new entry onto the stack:
const StartupRoute().push(context);

// Get the location string:
final loc = const StartupRoute().location;
context.go(loc); // or context.push(loc)
```

You can also use the `GoRouter` instance:
```dart
final router = ref.read(goRouterProvider);
router.go(const HomeRoute().location);
router.push(const ProfileRoute(userId: '123').location);
```

## Redirect helper signatures
Keep helpers consistent:
```dart
String? appStartupRedirect({required AppStartup appStartup}) { ... }

Future<String?> userAuthRedirect({
    required AuthFacade authFacade,
    required GoRouterState state,
}) async { ... }
```
- Return `null` to allow navigation.
- Return a location (string) to redirect.

### Example app startup redirect
```dart
String? appStartupRedirect({required AsyncValue<void> appStartup}) {
  if (appStartup.isLoading || appStartup.hasError) {
    return const StartupRoute().location;
  }
  return null;
}
```
- This redirect sends users to the startup flow while the app startup is loading or has failed; return `null` to allow normal navigation.

## Refreshing routes
- Use `GoRouterRefreshListenable` to watch streams or change notifiers and force re-evaluation of redirects.
- Example watches: auth state stream, app-startup stream, user preferences.

## Error / Not found
- Provide a lightweight `errorBuilder` to show a NotFound page.

## Testing tips
- Provide a test `navigatorKey` and a small set of generated routes for isolated tests.
- Wrap the widget under test with `ProviderScope` that overrides `authFacadePod` / `appStartupPod`.
- Use `await tester.pumpWidget(ProviderScope(child: MaterialApp.router(routerConfig: router)));` (or equivalent) and assert expected pages by looking for widgets or route locations.

## Summary checklist
- Use `@TypedGoRoute` + `GoRouteData` for type-safe routes.
- Rely on generated helpers (`.go()`, `.push()`, `.location`) for navigation.
- Keep redirect helpers pure and return `String?` / `Future<String?>`.
- Use `GoRouterRefreshListenable` to tie auth/startup streams to router refresh.
- Pass `$appRoutes` into the singleton `GoRouter` provider.

For quick reference, use the generated route helpers wherever possible to avoid manual string locations.