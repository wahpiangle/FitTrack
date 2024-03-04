import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/friend/search/search_helper.dart';
import 'package:group_project/pages/friend/search/user_image_display.dart';
import 'search/friend_search_bar.dart';

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
  StreamController<void> _updateController = StreamController<void>.broadcast();

  @override
  void dispose() {
    _updateController.close();
    super.dispose();
  }

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
      padding: const EdgeInsets.only(top: 60),
      child: StreamBuilder<void>(
        stream: _updateController.stream,
        builder: (context, snapshot) {
          return FutureBuilder<DocumentSnapshot>(
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
                  return FriendRequestTile(
                    friendUid: friendUid,
                    onFriendAccepted: () {
                      // Trigger an update when a friend is accepted
                      _updateController.add(null);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildSearchedUsersListView() {
    return SearchHelper.buildSearchResultsListView(searchedUsers);
  }
}


class FriendRequestTile extends StatelessWidget {
  final String friendUid;
  final VoidCallback onFriendAccepted;

  const FriendRequestTile({Key? key, required this.friendUid, required this.onFriendAccepted}) : super(key: key);
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
                    ImageDisplay.buildUserProfileImage(userData['photoUrl']),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['username'] ?? '',
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
              SizedBox(
                height: 28,
                child: ElevatedButton(
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
                    onFriendAccepted();
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
            ],
          );
        },
      ),
    );
  }
}

