import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'search_bar.dart';

class FriendRequestsTab extends StatefulWidget {
  const FriendRequestsTab({
    super.key,
  });

  @override
  FriendRequestsTabState createState() => FriendRequestsTabState();
}

class FriendRequestsTabState extends State<FriendRequestsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchedUsers = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            FriendSearchBar(
              controller: _searchController,
              onSearch: (results) {
                setState(() {
                  searchedUsers = results;
                });
              },
              onCancel: () {
                setState(() {
                  searchedUsers = [];
                });
              },
            ),
            buildContactsList(),
          ],
        ),
      ),
    );
  }

  Widget buildContactsList() {
    return Expanded(
      child: Stack(
        children: [
          const Center(
            child: Text(
              'Friend Request',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            buildSearchedUsersListView(),
          buildFriendRequestsList(),
        ],
      ),
    );
  }

  Widget buildFriendRequestsList() {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('friends').doc(currentUserUid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or a loading indicator
        }

        final requests = (snapshot.data?.data() as Map<String, dynamic>?)?['requests'] as List<dynamic>?;
        if (requests == null || requests.isEmpty) {
          return SizedBox.shrink(); // No friend requests
        }

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final friendUid = requests[index];
            return FriendRequestTile(friendUid: friendUid);
          },
        );
      },
    );
  }


  Widget buildSearchedUsersListView() {
    return  SearchHelper.buildSearchedUsersListView(searchedUsers);
  }
}


class FriendRequestTile extends StatelessWidget {
  final String friendUid;

  const FriendRequestTile({Key? key, required this.friendUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(friendUid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or a loading indicator
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>?;

          if (userData == null) {
            return SizedBox.shrink(); // User not found
          }

          return Row(
            children: [
              SearchHelper.buildUserProfileImage(userData['photoUrl']),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['name'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the logic to accept the friend request
                      // You can call a method to add the user as a friend here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColours.primary,
                      padding: EdgeInsets.all(8),
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
