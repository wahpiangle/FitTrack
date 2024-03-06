import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:group_project/constants/upload_enums.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/display_image_stack.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/home/components/display_post_image_screen.dart';
import 'package:group_project/pages/home/components/friends_post.dart';
import 'package:group_project/services/firebase/firebase_friends_post.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool? showCursor;
  String caption = '';
  int _current = 0;
  late Stream<List<FriendPostPair>> friendsPostStream;
  FirebaseFriendsPost firebaseFriendsPost = FirebaseFriendsPost();

  List<Post> imageList = [];

  @override
  void initState() {
    super.initState();

    fetchUserPosts();
    fetchFriendsPosts();
    fetchCaption(imageList.isNotEmpty
        ? imageList[_current].id
        : 0); // Adjusted for index out of range
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

  void fetchCaption(int workoutSessionId) async {
    String fetchedCaption =
        await FirebasePostsService.getCaption(workoutSessionId);
    setState(() {
      caption = fetchedCaption;
    });
  }

  void fetchUserPosts() async {
    List<Post> userPosts = await FirebasePostsService.getCurrentUserPosts();

    setState(() {
      imageList = userPosts;
      fetchCaption(imageList.isNotEmpty ? imageList[_current].id : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final UploadImageProvider uploadImageProvider =
        context.watch<UploadImageProvider>();

    return Scaffold(
      backgroundColor: AppColours.primary,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: imageList.length,
                  options: CarouselOptions(
                    aspectRatio: 1,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    enlargeFactor: 0.2,
                    viewportFraction: 0.5,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                        fetchCaption(imageList[index].id);
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final firstImage = imageList[index].firstImageUrl;
                    final secondImage = imageList[index].secondImageUrl;
                    final postId = imageList[index].id;
                    return Column(
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
                                controller:
                                    TextEditingController(text: caption),
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
                                    imagePath: imageList[index].firstImageUrl,
                                    imagePath2: imageList[index].secondImageUrl,
                                    workoutSessionId: imageList[index].id,
                                  ),
                                ),
                              );
                            },
                            child:
                                const Icon(Icons.comment, color: Colors.grey),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const FriendsPostCarousel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
