import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/constants/themes/app_colours.dart';



class FriendSuggestionsTab extends StatefulWidget {
  const FriendSuggestionsTab({super.key, required ScrollController controller, required MaterialColor color, required this.contacts});

  final List<Contact> contacts;

  @override
  FriendSuggestionsTabState createState() => FriendSuggestionsTabState();
}

class FriendSuggestionsTabState extends State<FriendSuggestionsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchedUsers = [];

  void _searchUsers(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('username', isLessThan: '${query.toLowerCase()}z')
        .get();

    final phoneSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isGreaterThanOrEqualTo: query)
        .where('phoneNumber', isLessThan: '${query}z')
        .get();

    final List<Map<String, dynamic>> combinedResults =
    [...snapshot.docs, ...phoneSnapshot.docs].map((doc) => doc.data()).toList();

    setState(() {
      searchedUsers = combinedResults;
    });
  }

  void _cancelSearch() {
    _searchController.clear();
    setState(() {
      searchedUsers = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Remove the focus from the TextField
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    _searchUsers(query);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search by username or phone number',
                    hintStyle: TextStyle(color: Colors.white),
                    fillColor: AppColours.primaryBright,
                    filled: true,
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey),
                    onPressed: _cancelSearch,
                  ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: widget.contacts.isEmpty
                      ? const Text('No contact found', style: TextStyle(color: Colors.white))
                      : ListView.builder(
                    itemCount: widget.contacts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(widget.contacts[index].displayName, style: const TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: searchedUsers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(searchedUsers[index]['displayName'], style: const TextStyle(color: Colors.white)),
                          );
                        },
                      ),
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

