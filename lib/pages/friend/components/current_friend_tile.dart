import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/pages/friend/search/user_image_display.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';

class CurrentFriendTile extends StatelessWidget {
  final List<FirebaseUser> currentFriends;
  final Future<void> Function() loadCurrentFriends;
  const CurrentFriendTile({
    super.key,
    required this.currentFriends,
    required this.loadCurrentFriends,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: ListView.separated(
        key: UniqueKey(),
        itemCount: currentFriends.length,
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.transparent, thickness: 0.2),
        itemBuilder: (context, index) {
          return ListTile(
            leading: ImageDisplay.buildUserProfileImage(
                currentFriends[index].photoUrl),
            title: Text(
              currentFriends[index].displayName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: FractionallySizedBox(
              widthFactor: 0.18,
              heightFactor: 0.50,
              child: ElevatedButton(
                onPressed: () {
                  FirebaseFriendsService.removeFriend(currentFriends[index].uid,
                      () {
                    loadCurrentFriends();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(8),
                  textStyle: const TextStyle(fontSize: 10),
                ),
                child: const Text(
                  'Remove',
                  key: Key('requestedText'),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
