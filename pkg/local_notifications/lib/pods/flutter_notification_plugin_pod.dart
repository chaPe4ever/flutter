import 'package:core/core.dart';
import 'package:local_notifications/exports/exports.dart';

part 'flutter_notification_plugin_pod.g.dart';

@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(Ref ref) {
  return FlutterLocalNotificationsPlugin();
}
