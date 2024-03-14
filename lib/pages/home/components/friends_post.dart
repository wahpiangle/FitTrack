import 'package:flutter/material.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_image_screen.dart';
import 'package:group_project/pages/home/components/reaction/reaction_button.dart';
import 'package:group_project/pages/home/components/reaction/reaction_images.dart';
import 'package:group_project/services/firebase/firebase_friends_post.dart';
import 'package:intl/intl.dart';

class FriendsPostCarousel extends StatefulWidget {
  const FriendsPostCarousel({super.key});

  @override
  State<FriendsPostCarousel> createState() => _FriendsPostCarouselState();
}

class _FriendsPostCarouselState extends State<FriendsPostCarousel> {
  Stream<List<FriendsPost>>? friendsPostStream;
  bool displayHoldInstruction = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchFriendsPosts();
    });
  }

  void fetchFriendsPosts() async {
    final firebaseFriendsPost = FirebaseFriendsPost();
    final stream = await firebaseFriendsPost.initFriendsPostStream();
    setState(() {
      friendsPostStream = stream;
    });
  }

  void showHoldInstruction() {
    setState(() {
      displayHoldInstruction = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        displayHoldInstruction = false;
      });
    });
  }

  void toggleState() {
    fetchFriendsPosts();
  }

  @override
  Widget build(BuildContext context) {
    return friendsPostStream != null
        ? StreamBuilder<List<FriendsPost>>(
            stream: friendsPostStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<FriendsPost> friendsPosts = snapshot.data!;
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: friendsPosts.length,
                  itemBuilder: (context, index) {
                    final friendPostData = friendsPosts[index];
                    final postReactions = friendPostData.reactions;
                    final postComments = friendPostData.comments;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  // TODO: Use the friend's profile picture
                                  backgroundImage: AssetImage(
                                    'assets/icons/defaultimage.jpg',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      friendPostData.friend.displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('EEEE, hh:mm:ss a')
                                          .format(friendPostData.post.date),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                friendPostData.post.firstImageUrl,
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
                                  friendPostData.post.secondImageUrl,
                                  fit: BoxFit.cover,
                                  width: 100,
                                ),
                              ),
                            ),
                            displayHoldInstruction
                                ? Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Container(
                                        color: const Color(0xFF000000),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            displayHoldInstruction
                                ? const Positioned.fill(
                                    child: Center(
                                      child: Text(
                                        'Hold the emoji button to react',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Column(
                                children: [
                                  const Icon(Icons.comment_sharp,
                                      color: Colors.white,
                                      size: 30,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 10,
                                        ),
                                      ]),
                                  const SizedBox(height: 10),
                                  ReactionButton(
                                    post: friendPostData.post,
                                    showHoldInstruction: showHoldInstruction,
                                    toggleState: toggleState,
                                  ),
                                ],
                              ),
                            ),
                            postReactions.isNotEmpty
                                ? Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: ReactionImages(
                                      postReactions: postReactions,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              friendPostData.post.caption.isEmpty
                                  ? const SizedBox.shrink()
                                  : Text(
                                      friendPostData.post.caption,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DisplayPostImageScreen(
                                        post: friendPostData.post,
                                        reactions: postReactions,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  postComments.isNotEmpty
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
