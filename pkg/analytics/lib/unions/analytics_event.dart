///
sealed class AnalyticsEvent;

///
final class FirebaseAnalyticsEvent extends AnalyticsEvent {
  ///
  new({required this.name, this.parameters});

  ///
  final String name;

  ///
  final Map<String, String>? parameters;
}
