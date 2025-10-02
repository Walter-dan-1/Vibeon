import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/models/user_model.dart';
import 'firestore_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = true;
  AuthService() {
    _auth.authStateChanges().listen((u) async {
      user = u;
      isLoading = false;
      notifyListeners();
      if (user != null) {
        try {
          final fs = FirestoreService();
          await fs.createUserIfNotExist(UserModel(uid: user!.uid, email: user!.email ?? '', displayName: user!.displayName, photoUrl: user!.photoURL));
        } catch (_) {}
      }
    });
  }

  Future<String?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      user = cred.user; notifyListeners(); return null;
    } catch (e) { return e.toString(); }
  }

  Future<String?> signIn(String email, String password) async {
    try { final cred = await _auth.signInWithEmailAndPassword(email: email, password: password); user = cred.user; notifyListeners(); return null; } catch (e) { return e.toString(); }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'Cancelled';
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final cred = await _auth.signInWithCredential(credential);
      user = cred.user; notifyListeners(); return null;
    } catch (e) { return e.toString(); }
  }

  Future<void> signOut() async { await _auth.signOut(); user = null; notifyListeners(); }
}
