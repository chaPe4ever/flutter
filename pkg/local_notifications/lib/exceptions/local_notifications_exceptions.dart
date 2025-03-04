import 'package:core/core.dart';
import 'package:local_notifications/constants/local_notifications_constants.dart';
import 'package:local_notifications/constants/trans_keys_constants.dart';

///
sealed class LocalNotificationsEx extends CoreException {
  const LocalNotificationsEx({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix = kLocalNotificationsPkgName,
  });
}

///
final class LocalNotificationsInitException extends LocalNotificationsEx {
  ///
  const LocalNotificationsInitException({
    super.messageKey = TransKeys.localNotificationsNotInitialisedKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}

final class LocalNotificationsShowException extends LocalNotificationsEx {
  ///
  const LocalNotificationsShowException({
    super.messageKey = TransKeys.localNotificationsShowFailedKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix,
  });
}
