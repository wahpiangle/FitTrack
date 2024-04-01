import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/user_profile/profile.dart';
import 'package:group_project/pages/user_profile/user_post_grid.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';
import 'package:group_project/models/firebase/firebase_user.dart';

class FriendStatusHandler extends StatelessWidget {
  final Future<FriendStatus> friendStatusFuture;
  final Future<List<Post>> postsFuture;
  final FirebaseUser user;
  final VoidCallback onStatusChanged;

  const FriendStatusHandler({
    super.key,
    required this.friendStatusFuture,
    required this.postsFuture,
    required this.user,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FriendStatus>(
      future: friendStatusFuture,
      builder: (context, statusSnapshot) {
        if (statusSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        switch (statusSnapshot.data) {
          case FriendStatus.friends:
            return UserPostsGrid(postsFuture: postsFuture, user: user);
          case FriendStatus.requestReceived:
            return ElevatedButton(
              onPressed: () async {
                await FirebaseFriendsService.acceptFriendRequest(user.uid, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend request accepted')),
                  );
                  onStatusChanged(); // Call the callback here
                });
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColours.secondary,
                foregroundColor: AppColours.primary,
              ),
              child: const Text(
                'Accept Friend Request',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          case FriendStatus.requestSent:
            return ElevatedButton(
              onPressed: () async {
                await FirebaseFriendsService.cancelFriendRequest(user.uid);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Friend request cancelled')),
                );
                onStatusChanged();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColours.secondary,
                foregroundColor: AppColours.primary,
              ),
              child: const Text(
                'Cancel Friend Request',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          default:
            return ElevatedButton(
              onPressed: () async {
                await FirebaseFriendsService.addFriend(user.uid);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Friend request sent to ${user.displayName}')),
                );
                onStatusChanged();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColours.secondary,
                foregroundColor: AppColours.primary,
              ),
              child: const Text(
                'Add Friend to See Posts',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
        }
      },
    );
  }
}
