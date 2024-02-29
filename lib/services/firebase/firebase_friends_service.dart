import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFriendsService {
  static Future<List<Map<String, dynamic>>> searchUsers(String searchText) async {
    final usernameSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .startAt([searchText])
        .endAt(['${searchText}z'])
        .get();

    final phoneSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isGreaterThanOrEqualTo: searchText)
        .where('phoneNumber', isLessThan: '${searchText}z')
        .get();

    return [
      ...usernameSnapshot.docs,
      ...phoneSnapshot.docs,
    ].map((doc) {
      Map<String, dynamic> data = doc.data();
      data['UID'] = doc.id;
      return data;
    }).toList();
  }

  static void addFriend(String friendUid) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      // Send friend request to the other user
      final friendRef = FirebaseFirestore.instance.collection('users').doc(friendUid);

      await friendRef.set({
        'requestReceived': FieldValue.arrayUnion([currentUserUid])
      }, SetOptions(merge: true));

      // Update the current user's document to include the sent request
      final currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserUid);

      await currentUserRef.set({
        'requestSent': FieldValue.arrayUnion([friendUid])
      }, SetOptions(merge: true));
    }
  }

}
