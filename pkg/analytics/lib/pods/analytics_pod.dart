import 'package:analytics/contracts/analytics_base.dart';
import 'package:analytics/implementations/firebase_analytics_impl.dart';
import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod/riverpod.dart';

part 'analytics_pod.g.dart';

///
@Riverpod(keepAlive: true)
AnalyticsBase analytics(Ref ref) =>
    FirebaseAnalyticsImpl(analytics: FirebaseAnalytics.instance);
