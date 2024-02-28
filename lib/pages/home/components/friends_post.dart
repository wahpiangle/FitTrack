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
  Stream<Post>? friendsPostStream;
  String caption = ''; // Define caption variable

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


  void fetchCaption() async {
    // Fetch the caption using the appropriate workout session ID
    final workoutSessionId = 1; // Example value, replace it with your logic
    String fetchedCaption = await FirebasePostsService.getCaption(
        workoutSessionId);
    setState(() {
      caption = fetchedCaption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return friendsPostStream != null
        ? StreamBuilder<Post>(
      stream: friendsPostStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final post = snapshot.data!;
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
                      bottom: 10, // Adjust the position from the bottom
                      right: 10, // Adjust the position from the right
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 40,
                              ),
                              const SizedBox(height: 5),
                              Icon(
                                Icons.comment,
                                color: Colors.blue,
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
                const SizedBox(height: 10), // Add spacing
                Center(
                  child: Text(
                    post.caption, // Display the fetched caption
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