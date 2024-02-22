import 'package:flutter/material.dart';
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
          const Center(
            child: Text(
              'Current Friends',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            buildSearchedUsersListView(),
        ],
      ),
    );
  }

  Widget buildSearchedUsersListView() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: searchedUsers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(searchedUsers[index]['displayName'] ?? '',
                  style: const TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }
}
