import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFriendsPost {
  late Stream<QuerySnapshot> friendsPostStream;

  void initFriendsPostStream() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    final friendIds = await getFriendsIds(currentUserUid);

    friendsPostStream = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', whereIn: friendIds)
        .snapshots();
  }

  Future<List<String>> getFriendsIds(String? currentUserUid) async {
    List<String> friendIds = [];

    if (currentUserUid != null) {
      try {
        // Fetch the document snapshot for the current user
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .get();

        // Check if the document exists and has data
        if (userDoc.exists) {
          // Retrieve the 'friends' field from the user document
          List<dynamic>? friends = userDoc.get('friends');

          if (friends != null && friends.isNotEmpty) {
            // Cast the dynamic list to a list of strings
            friendIds = friends.cast<String>().toList();
          }
        }
      } catch (e) {
        print('Error fetching friends: $e');
      }
    }

    return friendIds;
  }
}
