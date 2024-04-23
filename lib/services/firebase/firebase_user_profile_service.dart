import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_project/pages/user_profile/user_profile_page.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';

class FirebaseUserProfileService {
  static Future<int> getPostsCount(String userId) async {
    final posts = await FirebasePostsService.getPostsByUserId(userId);
    return posts.length;
  }

  static Future<int> getFriendsCount(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final friendsUids = userDoc.data()?['friends'] as List<dynamic>? ?? [];
    return friendsUids.length;
  }

  static Future<FriendStatus> checkFriendshipStatus(String friendUid) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    final currentUserDocSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
    final Map<String, dynamic> currentUserDocData =
        currentUserDocSnapshot.data() ?? {};

    if ((currentUserDocData['friends'] as List<dynamic>?)
            ?.contains(friendUid) ??
        false) {
      return FriendStatus.friends;
    } else if ((currentUserDocData['requestSent'] as List<dynamic>?)
            ?.contains(friendUid) ??
        false) {
      return FriendStatus.requestSent;
    } else if ((currentUserDocData['requestReceived'] as List<dynamic>?)
            ?.contains(friendUid) ??
        false) {
      return FriendStatus.requestReceived;
    } else {
      return FriendStatus.none;
    }
  }
}
