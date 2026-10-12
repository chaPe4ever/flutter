import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/core/widgets/texts/app_texts.dart';

import '../../../shared/pump_shared_ui_widget.dart';

void main() {
  testWidgets('App text widgets render all public sizes', (tester) async {
    await pumpSharedUiWidget(
      tester,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextHeadline.s('hs', color: Colors.red),
          TextHeadline.m('hm'),
          TextHeadline.l('hl'),
          TextTitle.m('tm'),
          TextTitle.l('tl'),
          TextBody.xs('bxs'),
          TextBody.s('bs'),
          TextBody.m('bm'),
          TextBody.l('bl'),
          TextLabel.s('ls'),
          TextLabel.m('lm'),
          TextLabel.l('ll'),
        ],
      ),
    );
    expect(find.text('hl'), findsOneWidget);
    expect(find.text('ll'), findsOneWidget);
  });

  testWidgets('text style resolvers throw for unsupported sizes', (
    tester,
  ) async {
    await pumpSharedUiWidget(
      tester,
      child: Builder(
        builder: (context) {
          expect(
            () => TextHeadline.withSize(TextSizeEnum.xs, 'x').style(context),
            throwsA(isA<UnknownCoreException>()),
          );
          expect(
            () => TextTitle.withSize(TextSizeEnum.xs, 'x').style(context),
            throwsA(isA<UnknownCoreException>()),
          );
          expect(
            () => TextTitle.withSize(TextSizeEnum.s, 'x').style(context),
            throwsA(isA<UnknownCoreException>()),
          );
          expect(
            () => TextLabel.withSize(TextSizeEnum.xs, 'x').style(context),
            throwsA(isA<UnknownCoreException>()),
          );
          return const SizedBox.shrink();
        },
      ),
    );
  });
}
