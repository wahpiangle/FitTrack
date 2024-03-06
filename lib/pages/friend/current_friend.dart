import 'package:flutter/material.dart';
import 'package:group_project/models/firebase_user.dart';
import 'package:group_project/pages/friend/components/current_friend_tile.dart';
import 'package:group_project/pages/friend/search/search_results_list.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';
import 'search/friend_search_bar.dart';

class CurrentFriendsTab extends StatefulWidget {
  const CurrentFriendsTab({super.key});

  @override
  CurrentFriendsTabState createState() => CurrentFriendsTabState();
}

class CurrentFriendsTabState extends State<CurrentFriendsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<FirebaseUser> searchedUsers = [];
  List<FirebaseUser> currentFriends = [];

  @override
  void initState() {
    super.initState();
    loadCurrentFriends();
  }

  Future<void> loadCurrentFriends() async {
    final friends = await FirebaseFriendsService.loadCurrentFriends();
    setState(() {
      currentFriends = friends;
    });
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
                    SearchResultList(searchResults: searchedUsers),
                  if (_searchController.text.isEmpty &&
                      currentFriends.isNotEmpty)
                    CurrentFriendTile(
                      currentFriends: currentFriends,
                      loadCurrentFriends: loadCurrentFriends,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
