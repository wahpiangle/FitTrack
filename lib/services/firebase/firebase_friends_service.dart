import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:group_project/models/firebase_user.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';

class FirebaseFriendsService {
  static Future<List<Map<String, dynamic>>> searchUsers(
      String searchText) async {
    searchText = searchText.toLowerCase();

    final usernameSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('username')
        .get();

    final List<Map<String, dynamic>> results = [];

    for (var doc in usernameSnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      final lowercaseName = data['username'].toLowerCase();
      if (lowercaseName.contains(searchText)) {
        data['UID'] = doc.id;
        results.add(data);
      }
    }

    return [
      ...results,
    ];
  }

  static void addFriend(String friendUid) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      final friendRef =
          FirebaseFirestore.instance.collection('users').doc(friendUid);

      await friendRef.set({
        'requestReceived': FieldValue.arrayUnion([currentUserUid])
      }, SetOptions(merge: true));

      final currentUserRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);

      await currentUserRef.set({
        'requestSent': FieldValue.arrayUnion([friendUid])
      }, SetOptions(merge: true));
    }
  }

  static Future<List<Map<String, dynamic>>> getFriendSuggestions() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      final currentUserRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);

      final currentUserFriendsSnapshot = await currentUserRef.get();
      final currentUserFriends =
          currentUserFriendsSnapshot.data()?['friends'] ?? [];
      final friendUids = currentUserFriends
          .map((friendUid) =>
              FirebaseFirestore.instance.collection('users').doc(friendUid))
          .toList();
      if (friendUids.isEmpty) {
        return [];
      }
      final friendsQuery = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: friendUids)
          .get();

      final Map<String, dynamic> userDataMap = {};
      final List<Map<String, dynamic>> suggestions = [];

      for (final friendDoc in friendsQuery.docs) {
        final friendData = userDataMap[friendDoc.id] ?? friendDoc;
        userDataMap[friendDoc.id] = friendData;

        final friendFriends = friendData.data()?['friends'] ?? [];

        for (final suggestedFriendUid in friendFriends) {
          if (suggestedFriendUid != currentUserUid &&
              !currentUserFriends.contains(suggestedFriendUid)) {
            final suggestedFriendData = userDataMap[suggestedFriendUid] ??
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(suggestedFriendUid)
                    .get();
            userDataMap[suggestedFriendUid] = suggestedFriendData;

            suggestions.add({
              'UID': suggestedFriendUid,
              ...suggestedFriendData.data(),
            });
          }
        }
      }

      return suggestions;
    }

    return [];
  }

  static void removeFriend(String friendUid, VoidCallback onRemoved) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      final currentUserRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      final friendRef =
          FirebaseFirestore.instance.collection('users').doc(friendUid);

      final batch = FirebaseFirestore.instance.batch();

      batch.update(currentUserRef, {
        'friends': FieldValue.arrayRemove([friendUid])
      });
      batch.update(friendRef, {
        'friends': FieldValue.arrayRemove([currentUserUid])
      });

      await batch.commit();

      onRemoved();
    }
  }

  static Future<void> acceptFriendRequest(
      String friendUid, VoidCallback onFriendAccepted) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('users').doc(friendUid).update({
      'friends': FieldValue.arrayUnion([currentUserUid])
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .update({
      'friends': FieldValue.arrayUnion([friendUid])
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .update({
      'requestReceived': FieldValue.arrayRemove([friendUid])
    });

    await FirebaseFirestore.instance.collection('users').doc(friendUid).update({
      'requestSent': FieldValue.arrayRemove([currentUserUid])
    });

    onFriendAccepted();
  }

  static Future<List<Map<String, dynamic>>> loadCurrentFriends() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    final friendsUid = userDoc.data()?['friends'] as List<dynamic>? ?? [];
    List<Map<String, dynamic>> friends = [];
    for (var friendUid in friendsUid) {
      final friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendUid)
          .get();
      friends.add({
        'UID': friendUid,
        ...?friendDoc.data(),
      });
    }

    return friends;
  }

  static Future<List<FirebaseUser>> getFriendRequestsDocuments() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final requests = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
    final requestsUids =
        requests.data()?['requestReceived'] as List<dynamic>? ?? [];
    final friendRequestsUserDocuments = <FirebaseUser>[];
    for (var requestUid in requestsUids) {
      final firebaseUser = await FirebaseUserService.getUserByUid(requestUid);
      friendRequestsUserDocuments.add(firebaseUser);
    }
    return friendRequestsUserDocuments;
  }
}
