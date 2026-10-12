import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/widgets/images/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppNetworkImage', () {
    testWidgets('builds CachedNetworkImage with default placeholder', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppNetworkImage(url: 'https://example.com/image.png'),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('uses custom placeholder and error widgets', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppNetworkImage(
            url: 'https://example.com/image.png',
            placeholder: Text('loading-image'),
            errorWidget: Text('failed-image'),
            width: 100,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      );

      expect(find.text('loading-image'), findsOneWidget);
    });

    testWidgets('uses default error icon builder when errorWidget is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppNetworkImage(url: 'https://example.com/image.png'),
        ),
      );

      final context = tester.element(find.byType(CachedNetworkImage));
      final cached = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      final errorChild = cached.errorWidget!.call(
        context,
        cached.imageUrl,
        Object(),
      );

      expect(errorChild, isA<Icon>());
    });
  });
}
