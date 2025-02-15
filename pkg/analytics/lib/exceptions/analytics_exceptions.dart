import 'package:analytics/constants/analytics_constants.dart';
import 'package:core/core.dart';

///
sealed class AnalyticsEx extends CoreException {
  const AnalyticsEx({
    required super.messageKey,
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
    super.prefix = kAnalyticsPkgName,
  });
}

///
final class WrongAnalyticsEventUsageException extends AnalyticsEx {
  ///
  WrongAnalyticsEventUsageException({
    super.messageKey = 'wrong_analytics_event_usage_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}

///
final class UnknownAnalyticsException extends AnalyticsEx {
  ///
  UnknownAnalyticsException({
    super.messageKey = 'unknown_analytics_exception_message_key',
    super.innerCode,
    super.innerError,
    super.innerMessage,
    super.st,
  });
}
