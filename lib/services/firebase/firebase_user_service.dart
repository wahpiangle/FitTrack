import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUserService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final usersCollectionRef = db.collection('users');

  // create user in firestore
  static Future<void> createUserInFirestore(User user, String name) async {
    final User user = auth.currentUser!;
    usersCollectionRef.doc(user.uid).set({
      'email': user.email,
      'name': name,
      'photoUrl': "",
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
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
    usersCollectionRef.doc(user.uid).update({'name': username});
  }

  static Future<String> getUsername() async {
    final User user = auth.currentUser!;
    final DocumentSnapshot doc = await usersCollectionRef.doc(user.uid).get();
    return doc['name'];
  }

  static Future<String> getProfilePicture() async {
    final User user = auth.currentUser!;
    final DocumentSnapshot doc = await usersCollectionRef.doc(user.uid).get();
    return doc['photoUrl'];
  }
}
