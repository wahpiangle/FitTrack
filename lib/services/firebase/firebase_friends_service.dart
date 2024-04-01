import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';

class FirebaseFriendsService {
  static Future<List<FirebaseUser>> searchUsers(String searchText) async {
    searchText = searchText.toLowerCase();

    final usernameSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('username')
        .get();

    final List<FirebaseUser> results = [];

    for (var doc in usernameSnapshot.docs) {
      FirebaseUser firebaseUser = await FirebaseUser.fromDocument(doc);
      if (firebaseUser.username.toLowerCase().contains(searchText)) {
        results.add(firebaseUser);
      }
    }

    return results;
  }

  static Future<Map<String, bool>> checkFriendRequestStatus(String friendUid) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == null) return {'sent': false, 'received': false};

    final currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();
    final userData = currentUserDoc.data();
    final requestsSent = userData?['requestSent'] as List<dynamic>? ?? [];
    final requestsReceived = userData?['requestReceived'] as List<dynamic>? ?? [];

    return {
      'sent': requestsSent.contains(friendUid),
      'received': requestsReceived.contains(friendUid),
    };
  }



  static Future<void> cancelFriendRequest(String friendUid) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == null) return;

    // Canceling the friend request
    await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
      'requestSent': FieldValue.arrayRemove([friendUid]),
    });
    await FirebaseFirestore.instance.collection('users').doc(friendUid).update({
      'requestReceived': FieldValue.arrayRemove([currentUserUid]),
    });
  }


  static addFriend(String friendUid) async {
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


  static Future<Map<FirebaseUser, int>> getFriendSuggestions() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    final currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    final currentUserFriendsUids = currentUserSnapshot.data()?['friends'];
    List<FirebaseUser> currentUserFriends = [];
    for (var friendUid in currentUserFriendsUids) {
      final friend = await FirebaseUserService.getUserByUid(friendUid);
      currentUserFriends.add(friend);
    }

    // get friends of friends, with count of how many friends in common
    final friendsOfFriends = <FirebaseUser, int>{};
    for (var friend in currentUserFriends) {
      final friendFriendsUid =
          await FirebaseUserService.getUserFriendsUidsByUid(friend.uid);
      for (var friendOfFriendUid in friendFriendsUid) {
        if (friendOfFriendUid == currentUserUid ||
            currentUserFriendsUids.contains(friendOfFriendUid)) {
          continue;
        } else {
          final friendOfFriend =
              await FirebaseUserService.getUserByUid(friendOfFriendUid);
          if (friendsOfFriends.containsKey(friendOfFriend)) {
            friendsOfFriends[friendOfFriend] =
                friendsOfFriends[friendOfFriend]! + 1;
          } else {
            friendsOfFriends[friendOfFriend] = 1;
          }
        }
      }
    }
    return friendsOfFriends;
  }

  static removeFriend(String friendUid, VoidCallback onRemoved) async {
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

  static Future<List<FirebaseUser>> loadCurrentFriends() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    final friendsUid = userDoc.data()?['friends'] as List<dynamic>? ?? [];
    List<FirebaseUser> friends = [];
    for (var friendUid in friendsUid) {
      final friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendUid)
          .get();
      final friend = await FirebaseUser.fromDocument(friendDoc);
      friends.add(friend);
    }

    return friends;
  }

  static Future<List<FirebaseUser>> getFriendRequestsDocuments() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final requests = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
    final requestsUids = requests.data()?['requestReceived'] ?? [];
    final friendRequestsUserDocuments = <FirebaseUser>[];
    for (var requestUid in requestsUids) {
      final firebaseUser = await FirebaseUserService.getUserByUid(requestUid);
      friendRequestsUserDocuments.add(firebaseUser);
    }
    return friendRequestsUserDocuments;
  }
}
