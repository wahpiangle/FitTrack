import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase_user.dart';
import 'package:group_project/pages/friend/search/search_bar_result.dart';

class SearchResultList extends StatelessWidget {
  final List<FirebaseUser> searchResults;
  const SearchResultList({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColours.primary,
      child: searchResults.isEmpty
          ? const Center(
              child: Text(
                'No result',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.separated(
              itemCount: searchResults.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.transparent, thickness: 0.5),
              itemBuilder: (context, index) {
                return SearchBarResult(friendUser: searchResults[index]);
              },
            ),
    );
  }
}
