import 'package:ads/contracts/consent_client.dart';
import 'package:ads/implementations/google_consent_client.dart';
import 'package:core/core.dart';

part 'consent.g.dart';

@Riverpod(keepAlive: true)
ConsentClient consentClient(Ref ref) => GoogleConsentClient();
