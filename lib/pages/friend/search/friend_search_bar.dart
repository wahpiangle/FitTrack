import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';

class FriendSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(List<Map<String, dynamic>>) onSearch;
  final Function() onCancel;

  const FriendSearchBar({
    super.key,
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
            onChanged: (query) async {
              final results =
                  await FirebaseFriendsService.searchUsers(controller.text);
              onSearch(results);
            },
            decoration: const InputDecoration(
              hintText: 'Search by username',
              hintStyle: TextStyle(color: Colors.white),
              fillColor: AppColours.primaryBright,
              filled: true,
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.grey),
              onPressed: () {
                controller.clear();
                onCancel();
              },
            ),
        ],
      ),
    );
  }
}
