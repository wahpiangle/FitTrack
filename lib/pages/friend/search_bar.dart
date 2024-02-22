import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/constants/themes/app_colours.dart';

class SearchHelper {
  static void searchUsers({
    required TextEditingController controller,
    required Function(List<Map<String, dynamic>>) onSearch,
    required Function() onCancel,
  }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: controller.text.toLowerCase())
        .where('username', isLessThan: '${controller.text.toLowerCase()}z')
        .get();

    final phoneSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isGreaterThanOrEqualTo: controller.text)
        .where('phoneNumber', isLessThan: '${controller.text}z')
        .get();

    final List<Map<String, dynamic>> combinedResults =
    [...snapshot.docs, ...phoneSnapshot.docs].map((doc) => doc.data()).toList();

    onSearch(combinedResults);
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

  const FriendSearchBar({
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
            style: TextStyle(color: Colors.white),
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
