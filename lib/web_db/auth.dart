import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get currentUser => _firebaseAuth.authStateChanges();

  Future<void> signIn() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}
