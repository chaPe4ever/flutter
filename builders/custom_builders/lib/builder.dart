library custom_builders;

import 'package:build/build.dart';
import 'package:custom_builders/generators/json_keys_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder jsonKeysGenerator(BuilderOptions options) =>
    SharedPartBuilder([JsonKeysGenerator()], 'json_keys_gen');
