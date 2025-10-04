import 'package:core/core.dart';

class FirebaseConfig implements ConfigBase {
  FirebaseConfig({required this.firebaseOptions});

  final FirebaseOptions firebaseOptions;

  @override
  Future<void> init() async {
    await Firebase.initializeApp(options: firebaseOptions);
  }
}
