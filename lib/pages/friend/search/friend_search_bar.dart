import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'search_helper.dart';

class FriendSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(List<Map<String, dynamic>>) onSearch;
  final Function() onCancel;

  const FriendSearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
    required this.onCancel,
  }) : super(key: key);

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
              SearchHelper.performSearch(
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

