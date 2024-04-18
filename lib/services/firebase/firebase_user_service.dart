import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:group_project/models/firebase/firebase_user.dart';

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
      usersCollectionRef.doc(user.uid).set({
        'email': user.email,
        'username': formattedUsername,
        'displayName': formattedUsername,
        'photoUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception('User already exists');
    }
  }

  static Future<void> createGoogleUserInFirestore(User user) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await usersCollectionRef.doc(user.uid).get();
    if (!doc.exists) {
      usersCollectionRef.doc(user.uid).set({
        'email': user.email,
        'username': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
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

  static Future<String> getUserDisplayName() async {
    final User user = auth.currentUser!;
    final DocumentSnapshot doc = await usersCollectionRef.doc(user.uid).get();
    return doc['displayName'];
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
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await usersCollectionRef.doc(uid).get();
      return FirebaseUser.fromDocument(doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<List<dynamic>> getUserFriendsUidsByUid(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await usersCollectionRef.doc(uid).get();
    return doc['friends'];
  }

  static Future<String?> getUserNameById(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await usersCollectionRef.doc(userId).get();

      if (userSnapshot.exists) {
        final userName = userSnapshot.data()?['username'] ?? '';
        return userName;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
