import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifications/contracts/notification_respponse_base.dart';

class NotificationResponseAdapter extends NotificationResponseBase {
  const NotificationResponseAdapter._({super.id, super.payload});

  factory NotificationResponseAdapter.adapt(NotificationResponse response) {
    return NotificationResponseAdapter._(
      id: response.id,
      payload: response.payload,
    );
  }
}
