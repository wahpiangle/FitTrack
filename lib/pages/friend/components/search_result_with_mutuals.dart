import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/pages/friend/search/search_bar_result.dart';

class SearchResultWithMutuals extends StatelessWidget {
  final Map<FirebaseUser, int> friendSuggestions;
  const SearchResultWithMutuals({
    super.key,
    required this.friendSuggestions,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: AppColours.primary,
        child: friendSuggestions.isEmpty
            ? const Center(
                child: Text(
                  'No result',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.separated(
                itemCount: friendSuggestions.length,
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.transparent, thickness: 0.5),
                itemBuilder: (context, index) {
                  return SearchBarResult(
                    friendUser: friendSuggestions.keys.toList()[index],
                    displayMutuals: true,
                  );
                },
              ),
      ),
    );
  }
}
