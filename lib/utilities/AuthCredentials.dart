import 'package:entangle/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:entangle/preferences.dart';
import 'package:entangle/screens/signup_screen.dart';
import '../main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:entangle/main.dart';

Future<bool> handleSignOut() async {
  setPassword(null);
  setEmail(null);
  try {
    User user = auth.currentUser;

    if (user.providerData[0].providerId == 'google.com') {
      print('google signout');
      await googleSignIn.disconnect();
    } else {
      FirebaseAuth.instance.signOut();
    }
  } catch (e) {
    print(e.message);
    FirebaseAuth.instance.signOut();
  }
}

bool checkPersistence() {
  getEmail().then((value) {
    userEmail = value;
  });
  getPassword().then((value) {
    userPassword = value;
  });
  if (userEmail != null && userPassword != null)
    return true;
  else
    return false;
}
