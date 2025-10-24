## Use the following common setup as a guidance for structuring the initial Flutter project.

### AppBoostrap:
```dart
final class AppBootstrap {
  const AppBootstrap._();

  static FutureOr<void> init({
    Widget? customRootWidget,
    Future<void> Function(ProviderContainer container)? testRootWidget,
  }) async {
    try {
      // Override the default error widget
      ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
        if (!kIsWeb && !Platform.isWindows) {
          appContainer
              .read(crashlyticsPod)
              .captureException(
                errorDetails.exception,
                stackTrace: errorDetails.stack,
              );
        }

        return AppErrorWidget(errorDetails: errorDetails);
      };

      await FlavorHelper.init().then(
        (e) => e.fold(
          (l) => throw l,
          (flavor) async =>
              AppConfig(
                configs: [
                  UtilsConfig(),
                  AppFirebaseConfig(
                    firebaseOptions: FirebaseOptionsHelper.getByFlavor(flavor),
                  ),                              
                  LocalizationConfig(),
                  SentryConfig(flavor: flavor),
                ],
              ).init(),
        ),
      );

      runApp(
        SentryWidget(
          child: UncontrolledProviderScope(
            container: appContainer,
            child: AppLocalization(
              child: customRootWidget ?? const App(),
            ),
          ),
        ),
      );
    } catch (e, st) {
      Log.error(e, st: st);
    }
  }
}
```

### Main:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final widgetsBinding = SentryWidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await AppBootstrap.init();
}
```

### App
```dart
lass GameRoomApp extends HookConsumerWidget {
  /// Ctr
  const GameRoomApp({super.key});

  static late BuildContext rootContext;

  static MaterialApp materialAppRouter({
    required BuildContext context,
    required GoRouter router,
    required ThemeBase theme,
    Widget? customChild,
    ThemeMode? themeMode,
  }) => MaterialApp.router(
    builder:
        (context, child) => MediaQuery(
          data: context.mediaQuery.copyWith(
            textScaler: context.textScaleFactor.clamp(
              minScaleFactor: 0.7,
              maxScaleFactor: 1,
            ),
          ),
          child: responsiveBuilder(
            context: context,
            child: customChild ?? child ?? const SizedBox(),
          ),
        ),
    scaffoldMessengerKey: scaffoldMessengerKey,
    debugShowCheckedModeBanner: false,
    theme: theme.light(context),
    darkTheme: theme.dark(context),
    themeMode: themeMode,
    localizationsDelegates: context.localizationDelegates,
    supportedLocales: context.supportedLocales,
    locale: context.locale,
    routerConfig: router,
  );

  static Widget responsiveBuilder({
    required Widget child,
    BuildContext? context,
    Color? backgroundColor,
  }) {
    return AppResponsiveBreakpoints.builder(
      debugLog: kDebugMode,
      child: AppMaxWidthBox(
        // A widget that limits the maximum width.
        // This is used to create a gutter area on either side of the content.
        maxWidth: BreakpointEnum.xl.end,
        backgroundColor: backgroundColor ?? context?.colors.backgroundPrimary,
        child: AppOverlays(child: child),
      ),
      breakpoints: [
        AppBreakpoint(
          start: BreakpointEnum.xs.start,
          end: BreakpointEnum.xs.end,
          name: BreakpointEnum.xs.name,
        ),
        AppBreakpoint(
          start: BreakpointEnum.s.start,
          end: BreakpointEnum.s.end,
          name: BreakpointEnum.s.name,
        ),
        AppBreakpoint(
          start: BreakpointEnum.m.start,
          end: BreakpointEnum.m.end,
          name: BreakpointEnum.m.name,
        ),
        AppBreakpoint(
          start: BreakpointEnum.l.start,
          end: BreakpointEnum.l.end,
          name: BreakpointEnum.l.name,
        ),
        AppBreakpoint(
          start: BreakpointEnum.xl.start,
          end: BreakpointEnum.xl.end,
          name: BreakpointEnum.xl.name,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    rootContext = context;
    final router = ref.watch(goRouterPod);
    final theme = ref.watch(themePod);

    return materialAppRouter(
      context: context,
      router: router,
      theme: theme,
      themeMode: ref.watch(themeModeNotifierPod),
    );
  }
}
```