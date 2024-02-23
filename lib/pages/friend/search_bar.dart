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
            ? Center(
          child: Text(
            'No result',
            style: const TextStyle(color: Colors.white),
          ),
        )
            : ListView.separated(
          itemCount: searchedUsers.length,
          separatorBuilder: (context, index) => const Divider(color: Colors.white, thickness: 0.5),
          itemBuilder: (context, index) {
            return ListTile(
              leading: buildUserProfileImage(searchedUsers[index]['photoUrl']),
              title: Text(
                searchedUsers[index]['name'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget buildUserProfileImage(String? photoUrl) {
    return CircleAvatar(
      backgroundImage: photoUrl != null
          ? NetworkImage(photoUrl)  // Load image from Firestore
          : const AssetImage('assets/icons/defaultimage.jpg') as ImageProvider,  // Use placeholder/default image
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
