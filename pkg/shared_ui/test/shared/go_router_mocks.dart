import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

class MockGoRouter extends Mock implements GoRouter {}

class MockGoRouteInformationProvider extends Mock
    implements GoRouteInformationProvider {}

MockGoRouter stubbedGoRouter({String path = '/', bool canPop = true}) {
  registerFallbackValue('/');
  final router = MockGoRouter();
  final info = MockGoRouteInformationProvider();
  when(() => info.value).thenReturn(RouteInformation(uri: Uri.parse(path)));
  when(() => router.routeInformationProvider).thenReturn(info);
  when(router.canPop).thenReturn(canPop);
  when(() => router.pop<Object?>(any<Object?>())).thenReturn(null);
  when(() => router.go(any())).thenReturn(null);
  when(() => router.push<void>(any())).thenAnswer((_) async {});
  return router;
}
