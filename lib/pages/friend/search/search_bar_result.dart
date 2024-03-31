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
    FirebaseFriendsService.checkFriendRequestStatus(widget.friendUser.uid).then((exists) {
      setState(() {
        friendRequestSent = exists;
      });
    });
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
              onPressed: () async {
                if (friendRequestSent) {
                  await FirebaseFriendsService.cancelFriendRequest(widget.friendUser.uid);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Friend request to ${widget.friendUser.displayName} canceled')),
                  );
                } else {
                  await FirebaseFriendsService.addFriend(widget.friendUser.uid);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Friend request sent to ${widget.friendUser.displayName}')),
                  );
                }

                // Update the state to reflect the change
                setState(() {
                  friendRequestSent = !friendRequestSent;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: friendRequestSent ? AppColours.secondaryLight : AppColours.secondary,
                padding: const EdgeInsets.all(8),
                textStyle: const TextStyle(fontSize: 10),
              ),
              child: Text(friendRequestSent ? 'Cancel' : 'Add', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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