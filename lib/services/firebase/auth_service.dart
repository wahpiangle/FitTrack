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

  // Auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map((User? user) => user);
  }

  // Check if the user is currently signed in
  bool isUserSignedIn() {
    final currentUser = _auth.currentUser;
    return currentUser != null;
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      objectBox.workoutSessionService.populateDataFromFirebase();
      objectBox.exerciseService.populateDataFromFirebase();
      return user;
    } catch (e) {
      throw e;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      user?.sendEmailVerification();
      FirebaseUserService.createUserInFirestore(user!, name);
      return user;
    } catch (e) {
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      List<Map<String, dynamic>> imageList = []; // Initialize with your image list

      await clearPostsSharedPreferences(imageList);
      objectBox.postService.clearAllPosts();
      await _auth.signOut();
    } catch (e) {
      throw e;
    }
  }

  // Clear SharedPreferences upon sign out
  Future<void> clearPostsSharedPreferences(
      List<Map<String, dynamic>> imageList) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      for (var image in imageList) {
        prefs.remove(image['firstImageUrl']);
        prefs.remove(image['secondImageUrl']);
        prefs.remove('caption_${image['workoutSessionId']}');
      }
    } catch (e) {
      print("Error clearing posts SharedPreferences: $e");
      throw e;
    }
  }

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String displayName,
    String? photoURL,
  }) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        await user.reload();
        user = getCurrentUser();
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential result =
      await _auth.signInWithCredential(credential);
      User? user = result.user;
      objectBox.workoutSessionService.populateDataFromFirebase();
      objectBox.exerciseService.populateDataFromFirebase();
      return user;
    } catch (e) {
      throw e;
    }
  }
}
