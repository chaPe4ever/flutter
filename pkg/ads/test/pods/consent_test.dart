import 'package:ads/implementations/google_consent_client.dart';
import 'package:ads/pods/consent.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('consentClientPod exposes the live Google consent client', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(consentClientPod), isA<GoogleConsentClient>());
  });
}
