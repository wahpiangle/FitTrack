import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/models/firebase_user.dart';
import 'package:group_project/pages/friend/components/friend_request_tile.dart';
import 'package:group_project/pages/friend/search/search_helper.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';
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
  final StreamController<void> _updateController =
      StreamController<void>.broadcast();
  List<FirebaseUser> requestDocumentList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadFriendRequests();
    });
  }

  @override
  void dispose() {
    _updateController.close();
    _searchController.dispose();
    super.dispose();
  }

  void loadFriendRequests() async {
    final requests = await FirebaseFriendsService.getFriendRequestsDocuments();
    setState(() {
      requestDocumentList = requests;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

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
            Expanded(
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
                    SearchHelper.buildSearchResultsListView(searchedUsers),
                  if (_searchController.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: StreamBuilder<void>(
                        stream: _updateController.stream,
                        builder: (context, snapshot) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUserUid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }

                              final requests = (snapshot.data?.data()
                                  as Map<String, dynamic>?)?['requestReceived'];
                              if (requests == null || requests.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return ListView.builder(
                                itemCount: requestDocumentList.length,
                                itemBuilder: (context, index) {
                                  return FriendRequestTile(
                                    userData: requestDocumentList[index],
                                    onFriendAccepted: () {
                                      _updateController.add(null);
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
