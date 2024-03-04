import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/pages/friend/search/search_helper.dart';
import 'package:group_project/pages/friend/search/user_image_display.dart';
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
    loadCurrentFriends();
  }

  void loadCurrentFriends() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();

      if (userDoc.exists) {
        final friends = userDoc.data()?['friends'] as List<dynamic>? ?? [];

        if (friends.isNotEmpty) {
          await fetchFriendDetails(friends);
        }
      }
    }
  }

  Future<void> fetchFriendDetails(List<dynamic> friendUids) async {
    final friendsQuery = await FirebaseFirestore.instance.collection('users').where(FieldPath.documentId, whereIn: friendUids).get();

    if (friendsQuery.docs.isNotEmpty) {
      setState(() {
        currentFriends = friendsQuery.docs.map((doc) {
          final Map<String, dynamic> data = doc.data();
          final List<String> friends = List<String>.from(data['friends'] ?? []);
          return {
            'UID': doc.id,
            ...data,
            'friends': friends,
          };
        }).toList();
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
            SearchHelper.buildSearchResultsListView(searchedUsers),
          if (_searchController.text.isEmpty && currentFriends.isNotEmpty)
            buildCurrentFriendsListView(),
        ],
      ),
    );
  }

  Widget buildCurrentFriendsListView() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: ListView.separated(
        itemCount: currentFriends.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.transparent, thickness: 0.2),
        itemBuilder: (context, index) {
          return ListTile(
            leading: ImageDisplay.buildUserProfileImage(currentFriends[index]['photoUrl']),
            title: Text(
              currentFriends[index]['displayName'] ?? '',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: FractionallySizedBox(
              widthFactor: 0.18,
              heightFactor: 0.55,
              child: ElevatedButton(
                onPressed: () {
                  FirebaseFriendsService.removeFriend(currentFriends[index]['UID']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFe2062c),
                  padding: const EdgeInsets.all(8),
                  textStyle: const TextStyle(fontSize: 10),
                ),
                child: const Text(
                    'Remove',
                    key: Key('requestedText'),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }



}