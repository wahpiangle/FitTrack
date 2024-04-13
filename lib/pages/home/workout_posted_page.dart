import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/upload_enums.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/current_user/display_image_stack.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_image_screen.dart';
import 'package:group_project/pages/home/components/friends_post/friends_post_list.dart';
import 'package:group_project/pages/home/components/reaction/reaction_images.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPostedPage extends StatefulWidget {
  final List<FirebaseUserPost> currentUserPosts;
  const WorkoutPostedPage({
    super.key,
    required this.currentUserPosts,
  });

  @override
  State<WorkoutPostedPage> createState() => _WorkoutPostedPageState();
}

class _WorkoutPostedPageState extends State<WorkoutPostedPage> {
  int _current = 0;
  bool _isScrollDisabled = false;

  @override
  void initState() {
    super.initState();
    context.read<UploadImageProvider>().getSharedPreferences();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool(UploadEnums.isUploading) == true) {
        context.read<UploadImageProvider>().setUploadError(true);
        context.read<UploadImageProvider>().setIsUploading(false);
      }
    });
  }

  void disableScroll() {
    setState(() {
      _isScrollDisabled = true;
    });
  }

  void enableScroll() {
    setState(() {
      _isScrollDisabled = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final UploadImageProvider uploadImageProvider =
        context.watch<UploadImageProvider>();
    //target
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
                              currentUserPosts: widget.currentUserPosts,
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
                                        firebaseUserPosts:
                                        widget.currentUserPosts,
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
                              : Text(
                            currentUserPostInfo.post.caption != ''
                                ? currentUserPostInfo.post.caption
                                : 'Add a caption...',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                },
              ),
              const FriendsPostList(),
            ],
          ),
        ),
      
      ),
    );
  }
}
