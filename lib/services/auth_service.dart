import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String ERROR_USER_NOT_FOUND = "ERROR_USER_NOT_FOUND";
const String ERROR_WRONG_PASSWORD = "ERROR_WRONG_PASSWORD";
const String ERROR_EMAIL_ALREADY_EXISTS = "ERROR_EMAIL_ALREADY_IN_USE";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login the user with an [email] and a [password]
  ///
  /// Throws [PlatformException] if the [email] or [password] is wrong.
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  /// Signup the user with an [email], [name], [password]
  ///
  /// Throws [PlatformException] if the [email] already exists.
  Future<void> signUp(String email, String name, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    var user = await _auth.currentUser();

    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .setData({'email': email, 'name': name});
  }

  /// Check if the user is logged in
  Future<bool> isLoggedIn() async {
    var user = await _auth.currentUser();

    if (user == null) {
      return false;
    } else {
      return true;
    }
  }
}
