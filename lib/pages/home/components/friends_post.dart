import 'package:flutter/material.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_friends_post.dart';

class FriendsPostCarousel extends StatefulWidget {
  const FriendsPostCarousel({super.key});

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
          final List<Post> posts = friendPostPair.posts;
          final friendName = friendPostPair.friendName;

          return Column(
            children: posts.map((post) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              // Add your profile image here
                              backgroundImage: AssetImage('assets/icons/defaultimage.jpg'),

                            ),
                            const SizedBox(width: 10),
                            Text(
                              friendName, // Display the friend's name
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            // Handle the onPressed event
                          },
                          color: Colors.white,
                        ),
                      ],
                    ),
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
                        const Positioned(
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
                                  SizedBox(height: 5),
                                  Icon(
                                    Icons.comment,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ],
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
            }).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },

    )
        : const Center(
      child: CircularProgressIndicator(),
    );
  }
}