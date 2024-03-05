import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:group_project/models/firebase_user.dart';

class FirebaseUserService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final usersCollectionRef = db.collection('users');

  // create user in firestore
  static Future<void> createUserInFirestore(User user, String username) async {
    final User user = auth.currentUser!;
    final formattedUsername = formatUsername(username);

    if (await checkIfUsernameExists(formattedUsername) == false) {
      await user.updateDisplayName(formattedUsername);

      usersCollectionRef.doc(user.uid).set({
        'email': user.email,
        'username': formattedUsername,
        'displayName': user.displayName,
        'photoUrl': "",
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception('User already exists');
    }
  }

  static Future<void> storeProfilePicture(String url) async {
    final User user = auth.currentUser!;
    try {
      final profileImageUpload =
          storage.ref('profilePictures/${user.uid}.jpg').putFile(File(url));
      final profileImageUrl =
          await (await profileImageUpload).ref.getDownloadURL();
      usersCollectionRef.doc(user.uid).update({'photoUrl': profileImageUrl});
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateUsername(String username) async {
    final User user = auth.currentUser!;
    final formattedUsername = formatUsername(username);
    final bool usernameExists = await checkIfUsernameExists(formattedUsername);
    if (!usernameExists) {
      usersCollectionRef.doc(user.uid).update({
        'username': formattedUsername,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception('Username already exists');
    }
  }

  static Future<String> getUsername() async {
    final User user = auth.currentUser!;
    final DocumentSnapshot doc = await usersCollectionRef.doc(user.uid).get();
    return doc['username'];
  }

  static Future<String> getProfilePicture() async {
    final User user = auth.currentUser!;
    final DocumentSnapshot doc = await usersCollectionRef.doc(user.uid).get();
    return doc['photoUrl'];
  }

  static Future<bool> checkIfUsernameExists(String username) async {
    final QuerySnapshot<Map<String, dynamic>> doc =
        await usersCollectionRef.where('username', isEqualTo: username).get();
    return doc.docs.isNotEmpty;
  }

  static String formatUsername(String username) {
    return username.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }

  static Future<void> updateDisplayName(String displayName) async {
    final User user = auth.currentUser!;
    user.updateDisplayName(displayName);
    await usersCollectionRef.doc(user.uid).update({'displayName': displayName});
  }

  static Future<FirebaseUser> getUserByUid(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await usersCollectionRef.doc(uid).get();
    return FirebaseUser.fromDocument(doc);
  }
}
