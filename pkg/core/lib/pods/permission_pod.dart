import 'package:core/permission/permission_base.dart';
import 'package:core/permission/permission_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_pod.g.dart';

/// App permission pod
@Riverpod(keepAlive: true)
PermissionBase permission(Ref ref) => PermissionImpl();
