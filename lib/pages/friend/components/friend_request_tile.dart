import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase_user.dart';
import 'package:group_project/pages/friend/search/user_image_display.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';

class FriendRequestTile extends StatelessWidget {
  final VoidCallback onFriendAccepted;
  final FirebaseUser userData;

  const FriendRequestTile({
    super.key,
    required this.onFriendAccepted,
    required this.userData,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageDisplay.buildUserProfileImage(userData.photoUrl),
      title: Text(
        userData.displayName,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        "@${userData.username}",
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
      trailing: SizedBox(
        height: 28,
        child: ElevatedButton(
          onPressed: () async {
            FirebaseFriendsService.acceptFriendRequest(
                userData.uid, onFriendAccepted);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColours.secondaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            textStyle: const TextStyle(fontSize: 10),
          ),
          child: const Text(
            'Accept',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
