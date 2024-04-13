import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';
import 'package:group_project/pages/home/components/friends_post/interactive_friends_post_image.dart';

class FriendPostCarousel extends StatefulWidget {
  final List<FirebaseUserPost> friendPostDataList;
  final void Function() toggleState;
  final Function onPageChanged;
  final PageController controller;
  const FriendPostCarousel({
    super.key,
    required this.friendPostDataList,
    required this.toggleState,
    required this.onPageChanged,
    required this.controller,
  });

  @override
  State<FriendPostCarousel> createState() => _FriendPostCarouselState();
}

class _FriendPostCarouselState extends State<FriendPostCarousel> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.friendPostDataList.length,
      scrollDirection: Axis.horizontal,
      controller: widget.controller,
      onPageChanged: (index) {
        widget.onPageChanged(index);
      },
      itemBuilder: (context, index) {
        final friendPostData = widget.friendPostDataList[index];
        return InteractiveFriendsPostImage(
          friendPostData: friendPostData,
          toggleState: widget.toggleState,
          isTappingSmallImage: false,
        );
      },
    );
    }
  }

