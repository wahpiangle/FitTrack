import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/pages/friend/search/user_image_display.dart';
import 'package:group_project/pages/user_profile/profile.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';

class SearchBarResult extends StatefulWidget {
  final FirebaseUser friendUser;
  final bool displayMutuals;

  const SearchBarResult({
    super.key,
    required this.friendUser,
    this.displayMutuals = false,
  });

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
    if (currentUserUid != null) {
      final currentUserRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      final currentUserData = (await currentUserRef.get()).data();
      final friendUid = widget.friendUser.uid;

      if (currentUserData != null &&
          currentUserData.containsKey('requestSent')) {
        final requestsSent = currentUserData['requestSent'] as List<dynamic>;
        setState(() {
          friendRequestSent = requestsSent.contains(friendUid);
        });
      }
    }
  }

  Future<void> addOrCancelFriend() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      final friendUid = widget.friendUser.uid;
      final currentUserRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);

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

        FirebaseFriendsService.addFriend(widget.friendUser.uid);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUserFriend = widget.friendUser.friends
        .contains(FirebaseAuth.instance.currentUser?.uid);

    bool isCurrentUser =
        widget.friendUser.uid == FirebaseAuth.instance.currentUser?.uid;

    return ListTile(
      leading: ImageDisplay.buildUserProfileImage(widget.friendUser.photoUrl),
      title: Text(
        widget.friendUser.displayName,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        "@${widget.friendUser.username} ${widget.displayMutuals ? '(${widget.friendUser.friends.length} mutual friends)' : ''}",
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
      trailing: FractionallySizedBox(
        widthFactor: 0.22,
        heightFactor: 0.50,
        child: isCurrentUser || isCurrentUserFriend
            ? const SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: addOrCancelFriend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: friendRequestSent
                          ? AppColours.secondaryLight
                          : AppColours.secondary,
                      padding: const EdgeInsets.all(8),
                      textStyle: const TextStyle(fontSize: 10),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: friendRequestSent
                          ? const Text(
                              'Cancel',
                              key: Key('requestedText'),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              'Add',
                              key: Key('addText'),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
      ),
      isThreeLine: true,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserProfilePage(user: widget.friendUser),
        ));
      },
    );
  }
}
