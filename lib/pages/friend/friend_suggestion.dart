import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:group_project/pages/friend/search/search_helper.dart';
import 'search/friend_search_bar.dart';

class FriendSuggestionsTab extends StatefulWidget {
  const FriendSuggestionsTab({
    super.key,
    required this.contacts,
  });

  final List<Contact> contacts;

  @override
  FriendSuggestionsTabState createState() => FriendSuggestionsTabState();
}

class FriendSuggestionsTabState extends State<FriendSuggestionsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchedUsers = [];

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
          Center(
            child: widget.contacts.isEmpty
                ? const Text('No contact found', style: TextStyle(color: Colors.white))
                : buildContactsListView(),
          ),
          if (_searchController.text.isNotEmpty)
            buildSearchedUsersListView(),
        ],
      ),
    );
  }


  Widget buildContactsListView() {
    return ListView.builder(
      itemCount: widget.contacts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(widget.contacts[index].displayName, style: const TextStyle(color: Colors.white)),
        );
      },
    );
  }

  Widget buildSearchedUsersListView() {
    return SearchHelper.buildSearchResultsListView(searchedUsers);
  }

}
