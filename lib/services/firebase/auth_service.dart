import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:group_project/main.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      objectBox.workoutSessionService.populateDataFromFirebase();
      objectBox.exerciseService.populateDataFromFirebase();
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

  Future signOut() async {
    try {
      // Retrieve the imageList from where it's defined or initialized
      List<Map<String, dynamic>> imageList = []; // Example initialization

      // Clear posts-related data upon sign-out from SharedPreferences
      await clearPostsSharedPreferences(imageList);

      // Clear posts-related data upon sign-out from ObjectBox
      objectBox.postService.clearAllPosts();

      return await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }


  Future<void> clearPostsSharedPreferences(List<Map<String, dynamic>> imageList) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // Remove image URL and caption
      for (var image in imageList) {
        prefs.remove(image['firstImageUrl']);
        prefs.remove(image['secondImageUrl']);
        prefs.remove('caption_${image['workoutSessionId']}');
      }
    } catch (e) {
      print("Error clearing posts SharedPreferences: $e");
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
      User? user = result.user;
      objectBox.workoutSessionService.populateDataFromFirebase();
      objectBox.exerciseService.populateDataFromFirebase();
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
