import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';

class FriendStatusButton extends StatelessWidget {
  final String uid;
  final Function() onStatusChanged;
  const FriendStatusButton({
    super.key,
    required this.uid,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColours.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        alignment: Alignment.center,
        child: PopupMenuButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          color: Colors.red,
          onSelected: (String value) {
            if (value == 'remove_friend') {
              FirebaseFriendsService.removeFriend(uid);
            }
          },
          offset: const Offset(0, 20),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'remove_friend',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.person_off, color: Colors.white),
                  const Text(
                    'Remove Friend',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text('Friends',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Icon(
                  Icons.expand_more_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
