import 'package:flutter/material.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_friends_post.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';

class FriendsPostCarousel extends StatefulWidget {
  const FriendsPostCarousel({Key? key}) : super(key: key);

  @override
  State<FriendsPostCarousel> createState() => _FriendsPostCarouselState();
}

class _FriendsPostCarouselState extends State<FriendsPostCarousel> {
  Stream<FriendPostPair>? friendsPostStream; // Change the stream type

  @override
  void initState() {
    super.initState();
    fetchFriendsPosts();
  }

  void fetchFriendsPosts() async {
    final firebaseFriendsPost = FirebaseFriendsPost();
    firebaseFriendsPost.initFriendsPostStream().then((stream) {
      setState(() {
        friendsPostStream = stream;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return friendsPostStream != null
        ? StreamBuilder<FriendPostPair>(
      stream: friendsPostStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final friendPostPair = snapshot.data!;
          final post = friendPostPair.post;
          final friendName = friendPostPair.friendName;
          return Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        post.firstImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          post.secondImageUrl,
                          fit: BoxFit.cover,
                          width: 100,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 40,
                              ),
                              const SizedBox(height: 5),
                              Icon(
                                Icons.comment,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ],
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    friendName, // Display the friend's name
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    post.caption,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}
