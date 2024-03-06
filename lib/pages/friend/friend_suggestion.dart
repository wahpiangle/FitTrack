import 'package:flutter/material.dart';
import 'package:group_project/models/firebase_user.dart';
import 'package:group_project/pages/friend/components/search_result_with_mutuals.dart';
import 'package:group_project/pages/friend/search/search_results_list.dart';
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
  List<FirebaseUser> searchedUsers = [];
  Map<FirebaseUser, int> friendSuggestions = {};

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
          Expanded(
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
                if (friendSuggestions.isNotEmpty)
                  SearchResultWithMutuals(friendSuggestions: friendSuggestions),
                if (searchedUsers.isNotEmpty)
                  SearchResultList(searchResults: searchedUsers),
                if (friendSuggestions.isEmpty && searchedUsers.isEmpty)
                  const Center(
                    child: Text(
                      'No Suggestion found',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
