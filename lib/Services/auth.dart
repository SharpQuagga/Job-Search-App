import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CUser {
  CUser({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<CUser> get onAuthStateChanged;
  Future<CUser> currentUser();
  Future<CUser> signInWithEmailAndPassword(String email, String password);
  Future<CUser> createUserWithEmailAndPassword(String email, String password);
  // Future<CUser> signInWithGoogle();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  CUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return CUser(uid: user.uid);
  }

  @override
  Stream<CUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<CUser> currentUser() async {
    final user =  _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }


  @override
  Future<CUser> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<CUser> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }


  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
