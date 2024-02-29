import 'package:flutter/material.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';
import 'package:group_project/pages/friend/search/search_bar_result.dart';


class SearchHelper {
  static void performSearch({
    required TextEditingController controller,
    required Function(List<Map<String, dynamic>>) onSearch,
    required Function() onCancel,
  }) async {
    final results = await FirebaseFriendsService.searchUsers(controller.text);
    onSearch(results);
  }

  static void cancelSearch({
    required TextEditingController controller,
    required Function() onCancel,
  }) {
    controller.clear();
    onCancel();
  }

  static Widget buildSearchResultsListView(List<Map<String, dynamic>> searchResults) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black,
        child: searchResults.isEmpty
            ? const Center(
          child: Text(
            'No result',
            style: TextStyle(color: Colors.white),
          ),
        )
            : ListView.separated(
          itemCount: searchResults.length,
          separatorBuilder: (context, index) => const Divider(color: Colors.transparent, thickness: 0.5),
          itemBuilder: (context, index) {
            return SearchBarResult(user: searchResults[index]);
          },
        ),
      ),
    );
  }
}


class ImageDisplay {
  static Widget buildUserProfileImage(String? photoUrl) {
    return CircleAvatar(
      radius: 22,
      backgroundImage: photoUrl != null
          ? NetworkImage(photoUrl)
          : const AssetImage('assets/icons/defaultimage.jpg') as ImageProvider,
    );
  }
}
