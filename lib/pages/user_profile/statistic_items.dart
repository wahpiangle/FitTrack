import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';

class StatItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isFriend;
  final String userId;
  final VoidCallback onFriendRemoved;

  const StatItem({
    Key? key,
    required this.label,
    required this.count,
    this.isFriend = false,
    required this.userId,
    required this.onFriendRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: screenWidth * 0.30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(label, style: const TextStyle(color: AppColours.secondaryLight, fontSize: 16)),
            ],
          ),
        ),
        if (isFriend)
          Container(
            width: screenWidth * 0.25,
            alignment: Alignment.topCenter,
            child: PopupMenuButton<String>(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              color: Colors.red,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Friends', style: TextStyle(color: AppColours.secondaryDark, fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.expand_more_outlined, color: AppColours.secondaryDark),
                ],
              ),
              onSelected: (String value) {
                if (value == 'remove_friend') {
                  FirebaseFriendsService.removeFriend(userId, () {
                    onFriendRemoved(); //refresh page
                  });
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'remove_friend',
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    leading: Icon(Icons.person_off, color: Colors.white),
                    title: Text('Remove Friend', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
