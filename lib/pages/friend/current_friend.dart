import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'search_bar.dart';

class CurrentFriendsTab extends StatefulWidget {
  const CurrentFriendsTab({
    super.key,
  });

  @override
  CurrentFriendsTabState createState() => CurrentFriendsTabState();
}

class CurrentFriendsTabState extends State<CurrentFriendsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchedUsers = [];
  List<Map<String, dynamic>> currentFriends = [];

  @override
  void initState() {
    super.initState();
    loadCurrentFriends();
  }

  void loadCurrentFriends() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (userDoc.exists) {
        final friends = userDoc.data()?['friends'] as List<dynamic>? ?? [];

        if (friends.isNotEmpty) {
          await fetchFriendDetails(friends);
        }
      }
    }
  }

  Future<void> fetchFriendDetails(List<dynamic> friendUids) async {
    final friendsQuery = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: friendUids)
        .get();

    if (friendsQuery.docs.isNotEmpty) {
      setState(() {
        currentFriends = friendsQuery.docs.map((doc) => doc.data()).toList();
      });
    } else {
      print('No friend details found for UIDs: $friendUids');
    }
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
                'Current Friends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            SearchHelper.buildSearchedUsersListView(searchedUsers),
          if (_searchController.text.isEmpty && currentFriends.isNotEmpty)
            buildCurrentFriendsListView(),
        ],
      ),
    );
  }


  Widget buildCurrentFriendsListView() {
    return ListView.separated(
      itemCount: currentFriends.length,
      separatorBuilder: (context, index) =>
      const Divider(color: Colors.white, thickness: 0.5),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 50),
          child: ListTile(
            leading:
            SearchHelper.buildUserProfileImage(currentFriends[index]['photoUrl']),
            title: Text(
              currentFriends[index]['name'] ?? '',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
