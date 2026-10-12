import 'package:core/enums/app_mode_enum.dart';
import 'package:core/utils/app_mode_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(AppModeHelper().reset);

  test('singleton starts in real mode', () {
    expect(AppModeHelper().currentMode, AppModeEnum.real);
    expect(identical(AppModeHelper(), AppModeHelper()), isTrue);
  });

  test('setMode updates current mode', () {
    AppModeHelper().setMode(AppModeEnum.fake);
    expect(AppModeHelper().currentMode, AppModeEnum.fake);
  });

  test('setMode no-ops when mode unchanged', () {
    AppModeHelper().setMode(AppModeEnum.real);
    AppModeHelper().setMode(AppModeEnum.real);
    expect(AppModeHelper().currentMode, AppModeEnum.real);
  });

  test('reset restores initial mode', () {
    AppModeHelper().setMode(AppModeEnum.fake);
    AppModeHelper().reset();
    expect(AppModeHelper().currentMode, AppModeEnum.real);
  });
}
