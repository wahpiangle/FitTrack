import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_project/main.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';

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
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      user?.sendEmailVerification();
      FirebaseUserService.createUserInFirestore(user!, name);
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
