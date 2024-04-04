import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_image_screen.dart';
import 'package:group_project/pages/home/components/friends_post/friend_post_carousel.dart';
import 'package:group_project/pages/user_profile/user_profile_page.dart';
import 'package:intl/intl.dart';

class FriendPost extends StatefulWidget {
  final FirebaseUser friend;
  final FirebaseUserPost friendPostData;
  final List<FirebaseUserPost> friendPostDataList;
  final void Function() toggleState;
  const FriendPost({
    super.key,
    required this.friend,
    required this.friendPostData,
    required this.friendPostDataList,
    required this.toggleState,
  });

  @override
  State<FriendPost> createState() => _FriendPostState();
}

class _FriendPostState extends State<FriendPost> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override void initState() {
    super.initState();
    modifyFriendPostDataListTo24h(widget.friendPostDataList);
  }

  void modifyFriendPostDataListTo24h(
      List<FirebaseUserPost> friendPostDataList) {
    final List<FirebaseUserPost> filteredPosts = [];
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    for (FirebaseUserPost post in friendPostDataList) {
      if (post.post.date.isAfter(yesterday)) {
        filteredPosts.add(post);
      }
    }
    friendPostDataList.clear();
    friendPostDataList.addAll(filteredPosts);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.friendPostDataList.isEmpty) {
      return SizedBox.shrink();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserProfilePage(user: widget.friend),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.friend.photoUrl,
                      imageBuilder: (context, imageProvider) =>
                          CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 20,
                          ),
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/icons/defaultimage.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.friendPostData.postedBy.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy, hh:mm:ss a').format(
                              widget.friendPostDataList[_currentIndex].post
                                  .date),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  //TODO: Handle the onPressed event
                },
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 500,
            child: FriendPostCarousel(
              friendPostDataList: widget.friendPostDataList,
              toggleState: widget.toggleState,
              onPageChanged: _onPageChanged,
              controller: _pageController,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
                widget.friendPostDataList.length,
                    (index) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          _pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor:
                          _currentIndex == index ? Colors.white : Colors.grey,
                        ),
                      ),
                    )),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.friendPostData.post.caption.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                  widget.friendPostDataList[_currentIndex].post.caption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DisplayPostImageScreen(
                              index: _currentIndex,
                              posterInfo: widget.friendPostData.postedBy,
                              firebaseUserPosts: widget.friendPostDataList,
                            ),
                      ),
                    );
                  },
                  child: Text(
                    widget.friendPostDataList[_currentIndex].comments.isNotEmpty
                        ? 'View all comments'
                        : 'Add a comment...',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}