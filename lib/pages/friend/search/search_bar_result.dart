import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/friend/search/user_image_display.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';

class SearchBarResult extends StatefulWidget {
  final Map<String, dynamic> user;

  const SearchBarResult({Key? key, required this.user}) : super(key: key);

  @override
  SearchBarResultState createState() => SearchBarResultState();
}

class SearchBarResultState extends State<SearchBarResult> {
  bool friendRequestSent = false;

  @override
  void initState() {
    super.initState();
    checkFriendRequestStatus();
  }

  Future<void> checkFriendRequestStatus() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null && widget.user['UID'] != null) {
      final currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      final currentUserData = (await currentUserRef.get()).data();
      final friendUid = widget.user['UID'];

      if (currentUserData != null && currentUserData.containsKey('requestSent')) {
        final requestsSent = currentUserData['requestSent'] as List<dynamic>;
        setState(() {
          friendRequestSent = requestsSent.contains(friendUid);
        });
      }
    }
  }

  Future<void> addOrCancelFriend() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null && widget.user['UID'] != null) {
      final friendUid = widget.user['UID'];
      final currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserUid);

      if (friendRequestSent) {
        await currentUserRef.set({
          'requestSent': FieldValue.arrayRemove([friendUid]),
        }, SetOptions(merge: true));

        setState(() {
          friendRequestSent = false;
        });
      } else {
        await currentUserRef.set({
          'requestSent': FieldValue.arrayUnion([friendUid]),
        }, SetOptions(merge: true));

        setState(() {
          friendRequestSent = true;
        });

        FirebaseFriendsService.addFriend(widget.user['UID']);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isCurrentUserFriend =
        (widget.user['friends'] as List<dynamic>?)?.contains(FirebaseAuth.instance.currentUser?.uid) ?? false;

    bool isCurrentUser = widget.user['UID'] == FirebaseAuth.instance.currentUser?.uid;

    return ListTile(
      leading: ImageDisplay.buildUserProfileImage(widget.user['photoUrl']),
      title: Text(
        widget.user['username'] ?? '',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: FractionallySizedBox(
        widthFactor: 0.22,
        heightFactor: 0.50,
        child: isCurrentUser || isCurrentUserFriend
            ? Container()
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: addOrCancelFriend,
              style: ElevatedButton.styleFrom(
                backgroundColor: friendRequestSent ? AppColours.secondaryLight : AppColours.secondary,
                padding: const EdgeInsets.all(8),
                textStyle: const TextStyle(fontSize: 10),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: friendRequestSent
                    ? const Text(
                  'Cancel',
                  key: Key('requestedText'),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                )
                    : const Text(
                  'Add',
                  key: Key('addText'),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
