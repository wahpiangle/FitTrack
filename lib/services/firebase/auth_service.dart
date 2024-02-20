import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_project/main.dart';

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

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      rethrow;
    }
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
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      user?.sendEmailVerification();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> updateUserProfile({
    required String displayName,
    String? photoURL,
  }) async {
    try {
      User? user = getCurrentUser();

      if (user != null) {
        // await user.updateProfile(displayName: displayName, photoURL: photoURL);
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        await user.reload();
        user = getCurrentUser();
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
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
