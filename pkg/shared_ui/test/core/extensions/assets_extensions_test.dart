import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/assets_gen/assets.gen.dart';
import 'package:shared_ui/core/extensions/assets_extensions.dart';

import '../../shared/pump_shared_ui_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SvgGenImageX', () {
    testWidgets('svgFromUIPkg builds SvgPicture', (tester) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return Assets.svg.chat.svgFromUIPkg(
              context,
              color: Colors.red,
              height: 32,
              width: 32,
            );
          },
        ),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    test('precache completes without throwing', () {
      expect(Assets.svg.chat.precache, returnsNormally);
    });
  });

  group('SvgPictureX', () {
    testWidgets('copyWith applies overrides', (tester) async {
      late SvgPicture original;
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            original = Assets.svg.chat.svgFromUIPkg(context);
            return original.copyWith(
              width: 40,
              height: 40,
              color: Colors.blue,
              semanticsLabel: 'chat',
            );
          },
        ),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
      final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(picture.width, 40);
      expect(picture.semanticsLabel, 'chat');
      expect(original, isNotNull);
    });

    testWidgets('copyWith keeps colorFilter when color omitted', (
      tester,
    ) async {
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            final withColor = Assets.svg.chat.svgFromUIPkg(
              context,
              color: Colors.green,
            );
            return withColor.copyWith(width: 20);
          },
        ),
      );
      final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(picture.colorFilter, isNotNull);
      expect(picture.width, 20);
    });
  });

  group('AssetGenImageX', () {
    testWidgets('imageFromUIPkg builds Image', (tester) async {
      final png = Assets.png.iconCluster;
      await pumpSharedUiWidget(
        tester,
        child: Builder(
          builder: (context) {
            return png.imageFromUIPkg(context, height: 20, width: 20);
          },
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
