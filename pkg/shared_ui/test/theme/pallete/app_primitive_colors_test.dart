import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/theme/pallete/app_primitive_colors.dart';

void main() {
  group('AppPrimitiveColors', () {
    test('exposes expected palette colors', () {
      expect(AppPrimitiveColors.baseBlackRegular, const Color(0xff0b0611));
      expect(AppPrimitiveColors.baseBlackLight, const Color(0xff16121f));
      expect(AppPrimitiveColors.baseGrayRegular, const Color(0xff565862));
      expect(AppPrimitiveColors.baseGrayLight, const Color(0xff9497a9));
      expect(AppPrimitiveColors.baseGrayExtraLight, const Color(0xffe6e6e6));
      expect(AppPrimitiveColors.baseWhiteRegular, const Color(0xfffdfdfd));
      expect(AppPrimitiveColors.basePurpleRegular, const Color(0xff6a0dad));
      expect(AppPrimitiveColors.basePurpleLight, const Color(0xffb57edc));
      expect(AppPrimitiveColors.basePurpleExtraLight, const Color(0xffeaddff));
      expect(AppPrimitiveColors.baseRedRegular, const Color(0xfff13b4d));
      expect(AppPrimitiveColors.baseRedDark, const Color(0xff6c1b14));
      expect(AppPrimitiveColors.baseBlueRegular, const Color(0xff151f44));
      expect(AppPrimitiveColors.baseBlueLight, const Color(0xff213358));
      expect(AppPrimitiveColors.baseBrownRegular, const Color(0xff64382c));
      expect(AppPrimitiveColors.baseYellowRegular, const Color(0xffe7d957));
      expect(AppPrimitiveColors.baseGreenRegular, const Color(0xff0ba51d));
    });
  });
}
