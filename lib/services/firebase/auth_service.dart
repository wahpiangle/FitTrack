import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/layout/user_profile_provider.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  //auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map((User? user) => user);
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      objectBox.initializeObjectBoxUponLogin();
      await objectBox.exerciseService.populateDataFromFirebase();
      await objectBox.workoutSessionService.populateDataFromFirebase();
      Provider.of<UserProfileProvider>(navigatorKey.currentContext!,
              listen: false)
          .loadAll();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      user?.sendEmailVerification();
      FirebaseUserService.createUserInFirestore(user!, username);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      objectBox.clearAll();
      Provider.of<UserProfileProvider>(navigatorKey.currentContext!,
              listen: false)
          .reset();
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in with Google
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      bool isFirstTime = result.additionalUserInfo!.isNewUser;
      if (isFirstTime) {
        await FirebaseUserService.createGoogleUserInFirestore(result.user!);
      }
      User? user = result.user;
      objectBox.initializeObjectBoxUponLogin();
      await objectBox.exerciseService.populateDataFromFirebase();
      await objectBox.workoutSessionService.populateDataFromFirebase();
      Provider.of<UserProfileProvider>(navigatorKey.currentContext!,
              listen: false)
          .loadAll();
      Navigator.pop(navigatorKey.currentContext!);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  //forgot password
  Future forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
