import 'package:flutter/material.dart';
import 'package:group_project/pages/friend/search/search_helper.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';
import 'search/friend_search_bar.dart';

class FriendSuggestionsTab extends StatefulWidget {
  const FriendSuggestionsTab({
    super.key,
  });

  @override
  FriendSuggestionsTabState createState() => FriendSuggestionsTabState();
}

class FriendSuggestionsTabState extends State<FriendSuggestionsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchedUsers = [];
  List<Map<String, dynamic>> friendSuggestions = [];

  @override
  void initState() {
    super.initState();
    loadFriendSuggestions();
  }

  Future<void> loadFriendSuggestions() async {
    final suggestions = await FirebaseFriendsService.getFriendSuggestions();
    setState(() {
      friendSuggestions = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
                'Suggestions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (friendSuggestions.isNotEmpty) buildFriendSuggestionsListView(),
          if (searchedUsers.isNotEmpty) buildSearchedUsersListView(),
          if (friendSuggestions.isEmpty && searchedUsers.isEmpty)
            const Center(
              child: Text('No Suggestion found',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget buildFriendSuggestionsListView() {
    return SearchHelper.buildSearchResultsListView(friendSuggestions);
  }

  Widget buildSearchedUsersListView() {
    return SearchHelper.buildSearchResultsListView(searchedUsers);
  }
}
