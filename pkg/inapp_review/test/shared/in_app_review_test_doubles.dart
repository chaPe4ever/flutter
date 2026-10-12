import 'package:analytics/analytics.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:inapp_review/implementations/in_app_review_service_impl.dart';

class FakeInAppReview implements InAppReview {
  FakeInAppReview({
    this.available = true,
  });

  bool available;
  int requestReviewCalls = 0;
  int openStoreListingCalls = 0;
  String? lastAppStoreId;
  String? lastMicrosoftStoreId;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<void> requestReview() async {
    requestReviewCalls++;
  }

  @override
  Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
  }) async {
    openStoreListingCalls++;
    lastAppStoreId = appStoreId;
    lastMicrosoftStoreId = microsoftStoreId;
  }
}

class FakeLocalStorage implements LocalStorageBase {
  final Map<String, dynamic> store = {};

  @override
  Future<void> write(String key, dynamic value) async {
    store[key] = value;
  }

  @override
  Future<T?> read<T>(String key) async => store[key] as T?;

  @override
  Future<void> remove(String key) async {
    store.remove(key);
  }

  @override
  Future<void> erase() async {
    store.clear();
  }

  @override
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback) => () {};
}

class FakeNetwork implements NetworkBase {
  FakeNetwork({this.connected = true});

  bool connected;

  @override
  Future<bool> get isConnected async => connected;

  @override
  Stream<NetworkStatus> get connectionStatusStream => const Stream.empty();

  @override
  void dispose() {}

  @override
  void addListener({VoidCallback? onOnline, VoidCallback? onOffline}) {}

  @override
  void removeListener({VoidCallback? onOnline, VoidCallback? onOffline}) {}
}

class FakeLogger implements LoggerBase {
  final List<String> debugMessages = [];
  final List<String> errorMessages = [];
  final List<String> infoMessages = [];

  @override
  void d(String message, {dynamic e, StackTrace? st}) {
    debugMessages.add(message);
  }

  @override
  void e(String message, {dynamic e, StackTrace? st}) {
    errorMessages.add(message);
  }

  @override
  void i(String message, {dynamic e, StackTrace? st}) {
    infoMessages.add(message);
  }

  @override
  void t(String message, {dynamic e, StackTrace? st}) {}

  @override
  void w(String message, {dynamic e, StackTrace? st}) {}
}

class FakeAnalytics implements AnalyticsBase {
  final List<AnalyticsEvent> events = [];

  @override
  Future<void> logEvent({required AnalyticsEvent analyticsEvent}) async {
    events.add(analyticsEvent);
  }

  @override
  Future<void> setAnalytics({required bool enabled}) async {}

  @override
  Future<void> setCurrentScreen({required String? screenName}) async {}

  @override
  Future<void> setUserId({String? id}) async {}
}

class FrequencyNullOnSecondReadStorage extends FakeLocalStorage {
  int _frequencyReads = 0;

  @override
  Future<T?> read<T>(String key) async {
    if (key == InAppReviewServiceImpl.durationMillisecondsFrequencyKey) {
      _frequencyReads++;
      if (_frequencyReads >= 3) {
        return null;
      }
    }
    return super.read(key);
  }
}

class ThrowingLocalStorage implements LocalStorageBase {
  ThrowingLocalStorage(this.error);

  final Exception error;

  @override
  Future<void> write(String key, dynamic value) async {
    throw error;
  }

  @override
  Future<T?> read<T>(String key) async => throw error;

  @override
  Future<void> remove(String key) async => throw error;

  @override
  Future<void> erase() async => throw error;

  @override
  VoidCallback listenKey(String key, ValueSetter<dynamic> callback) => () {};
}
