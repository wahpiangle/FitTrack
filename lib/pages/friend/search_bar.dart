import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/constants/themes/app_colours.dart';


class SearchHelper {
  static void searchUsers({
    required TextEditingController controller,
    required Function(List<Map<String, dynamic>>) onSearch,
    required Function() onCancel,
  }) async {
    final usernameSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: controller.text.toLowerCase())
        .where('name', isLessThan: '${controller.text.toLowerCase()}z')
        .get();

    final phoneSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isGreaterThanOrEqualTo: controller.text)
        .where('phoneNumber', isLessThan: '${controller.text}z')
        .get();

    final List<Map<String, dynamic>> combinedResults =
    [...usernameSnapshot.docs, ...phoneSnapshot.docs].map((doc) => doc.data()).toList();
    onSearch(combinedResults);
  }

  static Widget buildSearchedUsersListView(List<Map<String, dynamic>> searchedUsers) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black,
        child: searchedUsers.isEmpty
            ? const Center(
          child: Text(
            'No result',
            style: TextStyle(color: Colors.white),
          ),
        )
            : ListView.separated(
          itemCount: searchedUsers.length,
          separatorBuilder: (context, index) => const Divider(color: Colors.white, thickness: 0.5),
          itemBuilder: (context, index) {
            return SearchUserTile(user: searchedUsers[index]);
          },
        ),

      ),
    );
  }

  static void addFriend(String friendUid) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      // Update the current user's document to include the friend as a friend
      final currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserUid);

      final currentUserDoc = await currentUserRef.get();
      if (currentUserDoc.exists) {
        await currentUserRef.set({
          'friends': FieldValue.arrayUnion([friendUid])
        }, SetOptions(merge: true));
      } else {
        print('Warning: Current user document does not exist for UID: $currentUserUid');
      }

      // Update the friend's document to include the current user as a friend
      final friendRef = FirebaseFirestore.instance.collection('users').doc(friendUid);
      final friendDoc = await friendRef.get();

      if (friendDoc.exists) {
        await friendRef.set({
          'friends': FieldValue.arrayUnion([currentUserUid])
        }, SetOptions(merge: true));
      } else {
        print('Warning: Friend document does not exist for UID: $friendUid');
      }
    }
  }


  static Widget buildUserProfileImage(String? photoUrl) {
    return CircleAvatar(
      backgroundImage: photoUrl != null
          ? NetworkImage(photoUrl)
          : const AssetImage('assets/icons/defaultimage.jpg') as ImageProvider,
    );
  }

  static void cancelSearch({
    required TextEditingController controller,
    required Function() onCancel,
  }) {
    controller.clear();
    onCancel();
  }
}

class FriendSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(List<Map<String, dynamic>>) onSearch;
  final Function() onCancel;

  const FriendSearchBar({super.key,
    required this.controller,
    required this.onSearch,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            onChanged: (query) {
              SearchHelper.searchUsers(
                controller: controller,
                onSearch: onSearch,
                onCancel: onCancel,
              );
            },
            decoration: const InputDecoration(
              hintText: 'Search by username or phone number',
              hintStyle: TextStyle(color: Colors.white),
              fillColor: AppColours.primaryBright,
              filled: true,
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.grey),
              onPressed: () {
                SearchHelper.cancelSearch(
                  controller: controller,
                  onCancel: onCancel,
                );
              },
            ),
        ],
      ),
    );
  }
}

class SearchUserTile extends StatefulWidget {
  final Map<String, dynamic> user;

  const SearchUserTile({Key? key, required this.user}) : super(key: key);

  @override
  _SearchUserTileState createState() => _SearchUserTileState();
}

class _SearchUserTileState extends State<SearchUserTile> {
  bool friendRequestSent = false;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUserFriend =
        (widget.user['friends'] as List<dynamic>?)?.contains(FirebaseAuth.instance.currentUser?.uid) ?? false;

    return ListTile(
      leading: SearchHelper.buildUserProfileImage(widget.user['photoUrl']),
      title: Text(
        widget.user['name'] ?? '',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: FractionallySizedBox(
        widthFactor: 0.22,
        heightFactor: 0.6,
        child: isCurrentUserFriend
            ? Container() // If the user is a friend, show an empty container (hidden)
            : ElevatedButton(
          onPressed: () {
            if (!friendRequestSent && widget.user['UID'] != null) {
              setState(() {
                friendRequestSent = true;
              });

              SearchHelper.addFriend(widget.user['UID']);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: friendRequestSent ? AppColours.secondaryLight : AppColours.secondary,
            padding: EdgeInsets.all(8),
            textStyle: const TextStyle(fontSize: 11),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: friendRequestSent
                ? const Text(
              'Requested',
              key: Key('requestedText'),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )
                : const Text(
              'Add',
              key: Key('addText'),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
