import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/pages/friend/search/search_helper.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';
import 'search/friend_search_bar.dart';

class CurrentFriendsTab extends StatefulWidget {
  const CurrentFriendsTab({super.key});

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
    fetchFriendDetails();
  }

  Future<void> fetchFriendDetails() async {
    final friendUids = await FirebaseFriendsService.loadCurrentFriends();
    final friendsQuery = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: friendUids)
        .get();

    if (friendsQuery.docs.isNotEmpty) {
      setState(() {
        currentFriends = friendsQuery.docs.map((doc) => doc.data()).toList();
      });
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
            Expanded(
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
                    SearchHelper.buildSearchResultsListView(searchedUsers),
                  if (_searchController.text.isEmpty &&
                      currentFriends.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: ListView.separated(
                        itemCount: currentFriends.length,
                        separatorBuilder: (context, index) => const Divider(
                            color: Colors.transparent, thickness: 0.2),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: ImageDisplay.buildUserProfileImage(
                                currentFriends[index]['photoUrl']),
                            title: Text(
                              currentFriends[index]['displayName'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              currentFriends[index]['username'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
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
