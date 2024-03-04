import 'package:flutter/material.dart';
import 'package:group_project/services/firebase/firebase_friends_post.dart';

class FriendsPostCarousel extends StatefulWidget {
  const FriendsPostCarousel({super.key});

  @override
  State<FriendsPostCarousel> createState() => _FriendsPostCarouselState();
}

class _FriendsPostCarouselState extends State<FriendsPostCarousel> {
  Stream<List<FriendPostPair>>? friendsPostStream;

  @override
  void initState() {
    super.initState();
    fetchFriendsPosts();
  }

  void fetchFriendsPosts() async {
    final firebaseFriendsPost = FirebaseFriendsPost();
    final stream = await firebaseFriendsPost.initFriendsPostStream();
    setState(() {
      friendsPostStream = stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return friendsPostStream != null
        ? StreamBuilder<List<FriendPostPair>>(
      stream: friendsPostStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<FriendPostPair> friendPostPairs = snapshot.data!;

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            shrinkWrap: true, // Allow the ListView to wrap content
            itemCount: friendPostPairs.length,
            itemBuilder: (context, index) {
              final friendPostPair = friendPostPairs[index];
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              // Add your profile image here
                              backgroundImage: AssetImage(
                                'assets/icons/defaultimage.jpg',
                              ),
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
                                    color: Colors.grey,
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
            },
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

//TODO make friends second post viewable when swipe to right