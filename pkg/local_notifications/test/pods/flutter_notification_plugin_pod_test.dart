import 'package:core/core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications/pods/flutter_notification_plugin_pod.dart';

void main() {
  test('flutterLocalNotificationsPluginPod exposes a plugin instance', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final plugin = container.read(flutterLocalNotificationsPluginPod);

    expect(plugin, isA<FlutterLocalNotificationsPlugin>());
  });
}
