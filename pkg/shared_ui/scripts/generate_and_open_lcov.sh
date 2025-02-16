#!/bin/bash

cd "$(dirname "$0")" || exit

cd .. &&
flutter test --coverage &&
lcov --ignore-errors unused --remove coverage/lcov.info '**.freezed.dart' '**.g.dart' '**.gr.dart' '**/generated_plugin_registrant.dart' -o coverage/filtered_lcov.info &&
genhtml coverage/filtered_lcov.info -o coverage/html &&
open coverage/html/index.html
