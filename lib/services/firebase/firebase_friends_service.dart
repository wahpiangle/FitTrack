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

  static Future<List<Map<String, dynamic>>> getFriendSuggestions() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      final currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserUid);

      final currentUserFriendsSnapshot = await currentUserRef.get();
      final currentUserFriends = currentUserFriendsSnapshot.data()?['friends'] ?? [];

      final suggestions = <Map<String, dynamic>>[];

      for (final friendUid in currentUserFriends) {
        final friendRef = FirebaseFirestore.instance.collection('users').doc(friendUid);
        final friendSnapshot = await friendRef.get();
        final friendFriends = friendSnapshot.data()?['friends'] ?? [];

        for (final suggestedFriendUid in friendFriends) {
          if (suggestedFriendUid != currentUserUid && !currentUserFriends.contains(suggestedFriendUid)) {
            final suggestedFriendRef = FirebaseFirestore.instance.collection('users').doc(suggestedFriendUid);
            final suggestedFriendSnapshot = await suggestedFriendRef.get();
            final suggestedFriendData = suggestedFriendSnapshot.data();

            if (suggestedFriendData != null) {
              suggestions.add({
                'UID': suggestedFriendUid,
                ...suggestedFriendData,
              });
            }
          }
        }
      }

      return suggestions;
    }

    return [];
  }

  static void removeFriend(String friendUid) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      final currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      final friendRef = FirebaseFirestore.instance.collection('users').doc(friendUid);

      await currentUserRef.update({
        'friends': FieldValue.arrayRemove([friendUid]),
      });

      await friendRef.update({
        'friends': FieldValue.arrayRemove([currentUserUid]),
      });
    }
  }
}