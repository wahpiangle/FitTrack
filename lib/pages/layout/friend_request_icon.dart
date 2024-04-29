import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/services/firebase/auth_service.dart';

class FriendRequestIcon extends StatefulWidget {
  const FriendRequestIcon({super.key});

  @override
  State<FriendRequestIcon> createState() => _FriendRequestIconState();
}

class _FriendRequestIconState extends State<FriendRequestIcon> {
  final currentUserUid = AuthService().getCurrentUser()!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Icon(Icons.person_add_alt_1, color: Colors.white);
          }
          final friendRequests = (snapshot.data!.data()
                  as Map<String, dynamic>)['requestReceived'] ??
              [];
          return friendRequests.length > 0
              ? const Stack(
                  children: [
                    Icon(Icons.person_add_alt_1, color: Colors.white),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: SizedBox(
                        height: 10,
                        width: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    )
                  ],
                )
              : const Icon(Icons.person_add_alt_1, color: Colors.white);
        });
  }
}
