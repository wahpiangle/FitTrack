import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/upload_enums.dart';
import 'package:group_project/models/firebase/CurrentUserPost.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/current_user/display_image_stack.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_image_screen.dart';
import 'package:group_project/pages/home/components/friends_post.dart';
import 'package:group_project/pages/home/components/reaction/reaction_images.dart';
import 'package:group_project/services/firebase/firebase_friends_post.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPostedPage extends StatefulWidget {
  final List<CurrentUserPost> currentUserPosts;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchFriendsPosts();
    });
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
                  final currentUserPostInfo = widget.currentUserPosts[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          child: DisplayImageStack(
                            currentUserPostInfo: currentUserPostInfo,
                            index: index,
                            current: _current,
                          ),
                        ),
                        const SizedBox(height: 10),
                        currentUserPostInfo.reactions.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DisplayPostImageScreen(
                                        post: currentUserPostInfo.post,
                                        reactions:
                                            currentUserPostInfo.reactions,
                                      ),
                                    ),
                                  );
                                },
                                child: ReactionImages(
                                  postReactions: currentUserPostInfo.reactions,
                                  isCurrentUserPost: true,
                                ),
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
                                    currentUserPostInfo.post.postId,
                                    caption,
                                  );
                                },
                                controller: TextEditingController(
                                  text: currentUserPostInfo.post.caption,
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
