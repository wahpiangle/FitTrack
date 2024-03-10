import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/upload_enums.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/display_image_stack.dart';
import 'package:group_project/pages/home/components/display_post_image_screen.dart';
import 'package:group_project/pages/home/components/friends_post.dart';
import 'package:group_project/pages/home/components/reaction/reaction_images.dart';
import 'package:group_project/services/firebase/firebase_friends_post.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPostedPage extends StatefulWidget {
  final List<Post> currentUserPosts;
  const WorkoutPostedPage({
    super.key,
    required this.currentUserPosts,
  });

  @override
  State<WorkoutPostedPage> createState() => _WorkoutPostedPageState();
}

class _WorkoutPostedPageState extends State<WorkoutPostedPage> {
  int _current = 0;
  late Stream<List<FriendsPost>> friendsPostStream;
  List<Reaction> postReactions = [];

  @override
  void initState() {
    super.initState();
    fetchPostReactions(widget.currentUserPosts[_current].postId);
    fetchFriendsPosts();
    context.read<UploadImageProvider>().getSharedPreferences();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool(UploadEnums.isUploading) == true) {
        context.read<UploadImageProvider>().setUploadError(true);
        context.read<UploadImageProvider>().setIsUploading(false);
      }
    });
  }

  void fetchFriendsPosts() async {
    FirebaseFriendsPost().initFriendsPostStream().then((stream) {
      setState(() {
        friendsPostStream = stream;
      });
    });
  }

  void fetchPostReactions(String postId) async {
    final List<Reaction> reactions =
        await FirebasePostsService.getReactionsByPostId(postId);
    setState(() {
      postReactions = reactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UploadImageProvider uploadImageProvider =
        context.watch<UploadImageProvider>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: widget.currentUserPosts.length,
                options: CarouselOptions(
                  aspectRatio: 0.9,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  enlargeFactor: 0.2,
                  viewportFraction: 0.5,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final firstImage =
                      widget.currentUserPosts[index].firstImageUrl;
                  final secondImage =
                      widget.currentUserPosts[index].secondImageUrl;
                  final postId = widget.currentUserPosts[index].id;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          child: DisplayImageStack(
                            firstImageUrl: firstImage,
                            secondImageUrl: secondImage,
                            index: index,
                            current: _current,
                            postId: postId,
                          ),
                        ),
                        const SizedBox(height: 10),
                        postReactions.isNotEmpty
                            ? ReactionImages(
                                postReactions: postReactions,
                                isCurrentUserPost: true,
                              )
                            : const SizedBox(),
                        uploadImageProvider.uploadError
                            ? const Text(
                                'There was an error uploading your workout. Please try again.',
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              )
                            : TextField(
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                                enableInteractiveSelection: false,
                                decoration: const InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: 'Add a caption..',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                onChanged: (caption) {
                                  FirebasePostsService.saveCaption(
                                    postId,
                                    caption,
                                  );
                                },
                                controller: TextEditingController(
                                  text: widget.currentUserPosts[index].caption,
                                ),
                              ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayPostImageScreen(
                                    imagePath: widget
                                        .currentUserPosts[index].firstImageUrl,
                                    imagePath2: widget
                                        .currentUserPosts[index].secondImageUrl,
                                    workoutSessionId:
                                        widget.currentUserPosts[index].id,
                                  ),
                                ),
                              );
                            },
                            child:
                                const Icon(Icons.comment, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const FriendsPostCarousel(),
            ],
          ),
        ),
      ),
    );
  }
}
