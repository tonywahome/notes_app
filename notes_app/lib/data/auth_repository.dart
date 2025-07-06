import 'package:firebase_auth/firebase_auth.dart';
import '../domain/app_user.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebase(User? user) {
    if (user == null) return null;
    return AppUser(uid: user.uid, email: user.email ?? '');
  }

  Stream<AppUser?> get userChanges =>
      _auth.authStateChanges().map(_userFromFirebase);

  Future<AppUser?> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(cred.user);
  }

  Future<AppUser?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(cred.user);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  AppUser? get currentUser => _userFromFirebase(_auth.currentUser);
}
