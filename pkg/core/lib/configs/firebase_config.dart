import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig implements Config {
  FirebaseConfig({required this.firebaseOptions});

  final FirebaseOptions firebaseOptions;

  @override
  Future<void> init() async {
    await Firebase.initializeApp(options: firebaseOptions);
  }
}
