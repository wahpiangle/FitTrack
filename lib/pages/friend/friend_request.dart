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
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Friend Request',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            buildSearchedUsersListView(),
          if (_searchController.text.isEmpty)
          buildFriendRequestsList(),
        ],
      ),
    );
  }


  Widget buildFriendRequestsList() {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(currentUserUid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final requests = (snapshot.data?.data() as Map<String, dynamic>?)?['requestReceived'] as List<dynamic>?;
          if (requests == null || requests.isEmpty) {
            return const SizedBox.shrink();
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final friendUid = requests[index];
              return FriendRequestTile(friendUid: friendUid);
            },
          );
        },
      ),
    );
  }


  Widget buildSearchedUsersListView() {
    return  SearchHelper.buildSearchedUsersListView(searchedUsers);
  }
}


class FriendRequestTile extends StatelessWidget {
  final String friendUid;

  const FriendRequestTile({super.key, required this.friendUid});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(friendUid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          if (userData == null) {
            return const SizedBox.shrink();
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SearchHelper.buildUserProfileImage(userData['photoUrl']),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['name'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

                  await FirebaseFirestore.instance.collection('users').doc(friendUid).update({
                    'friends': FieldValue.arrayUnion([currentUserUid])
                  });

                  await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
                    'friends': FieldValue.arrayUnion([friendUid])
                  });

                  await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
                    'requestReceived': FieldValue.arrayRemove([friendUid])
                  });

                  await FirebaseFirestore.instance.collection('users').doc(friendUid).update({
                    'requestSent': FieldValue.arrayRemove([currentUserUid])
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColours.secondaryLight,
                  padding: const EdgeInsets.all(8),
                  textStyle: const TextStyle(fontSize: 11),
                ),
                child: const Text(
                  'Accept',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

