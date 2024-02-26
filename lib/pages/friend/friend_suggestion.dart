import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'search_bar.dart';

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
    return SearchHelper.buildSearchedUsersListView(searchedUsers);
  }

}
