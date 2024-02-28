import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFriendsService {
  static Future<List<Map<String, dynamic>>> searchUsers(String searchText) async {
    searchText = searchText.toLowerCase();

    final usernameSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .get();


    final List<Map<String, dynamic>> results = [];

    for (var doc in usernameSnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      final lowercaseName = data['name'].toLowerCase();
      if (lowercaseName.contains(searchText)) {
        data['UID'] = doc.id;
        results.add(data);
      }
    }

    return [
      ...results.toList(),
    ];
  }

  static void addFriend(String friendUid) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      // Send friend request to the other user
      final friendRef = FirebaseFirestore.instance.collection('users').doc(friendUid);

      await friendRef.set({
        'requestReceived': FieldValue.arrayUnion([currentUserUid])
      }, SetOptions(merge: true));

      final currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserUid);

      await currentUserRef.set({
        'requestSent': FieldValue.arrayUnion([friendUid])
      }, SetOptions(merge: true));
    }
  }

}
