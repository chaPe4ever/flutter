///
sealed class AnalyticsEvent {}

///
final class FirebaseAnalyticsEvent extends AnalyticsEvent {
  ///
  FirebaseAnalyticsEvent({
    required this.name,
    this.parameters,
  });

  ///
  final String name;

  ///
  final Map<String, Object>? parameters;
}
