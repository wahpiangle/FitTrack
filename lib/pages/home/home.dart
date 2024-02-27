import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:group_project/constants/upload_enums.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/display_image_stack.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/home/components/display_post_image_screen.dart';
import 'package:group_project/services/firebase/firebase_friends_post.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final bool? showCursor;
  String caption = ''; // Define caption variable
  int _current = 0;
  final List<Map<String, dynamic>> imageList = objectBox.postService
      .getActivePosts()
      .asMap()
      .entries
      .map((entry) {
    final item = entry.value;
    return {
      'firstImageUrl': item.firstImageUrl,
      'secondImageUrl': item.secondImageUrl,
      'postId': item.id,
      'workoutSessionId': item.workoutSession.targetId,
    };
  }).toList();
  late Stream<Post> friendsPostStream = Stream.empty(); // Initialize with an empty stream
  FirebaseFriendsPost firebaseFriendsPost = FirebaseFriendsPost();

  @override
  void initState() {
    super.initState();
    // Fetch the caption for the initial workout session
    fetchCaption(imageList[_current]['workoutSessionId']);
    context.read<UploadImageProvider>().getSharedPreferences();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool(UploadEnums.isUploading) == true) {
        // Handle the case where the app was force quit during upload
        context.read<UploadImageProvider>().setUploadError(true);
        context.read<UploadImageProvider>().setIsUploading(false);
      }
    });

    FirebaseFriendsPost().initFriendsPostStream().then((stream) {
      setState(() {
        friendsPostStream = stream;
      });
    });
  }

  void fetchCaption(int workoutSessionId) async {
    // Fetch the caption using the provided workout session ID
    String fetchedCaption = await FirebasePostsService.getCaption(
        workoutSessionId);
    setState(() {
      caption = fetchedCaption;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UploadImageProvider uploadImageProvider = context.watch<
        UploadImageProvider>();
    bool hasImages = imageList.isNotEmpty; // Check if there are images

    return Scaffold(
      backgroundColor: AppColours.primary,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 5),
                if (hasImages) const SizedBox(height: 1),
                // Reduce the vertical space here
                CarouselSlider.builder(
                  itemCount: imageList.length,
                  options: CarouselOptions(
                    aspectRatio: 0.9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    enlargeFactor: 0.2,
                    viewportFraction: 0.45,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                        // Fetch caption for the current workout session ID
                        fetchCaption(imageList[index]['workoutSessionId']);
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final firstImage = imageList[index]['firstImageUrl']!;
                    final secondImage = imageList[index]['secondImageUrl']!;
                    final postId = imageList[index]['postId']!;
                    final workoutSessionId = imageList[index]['workoutSessionId']!;
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
                              workoutSessionId: workoutSessionId,
                            ),
                          ),
                          uploadImageProvider.uploadError
                              ? const Text(
                            'There was an error uploading your workout. Please try again.',
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                              : Container(
                            width: 100,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 1, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border:
                              Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              showCursor: false,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                              enableInteractiveSelection: false,
                              decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                hintText: 'Add a caption..',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 16),
                              ),
                              onChanged: (caption) {
                                FirebasePostsService.saveCaption(
                                    workoutSessionId, caption);
                              },
                              controller:
                              TextEditingController(text: caption),
                            ),
                          ),
                          // Add Row widget for icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Icon(Icons.favorite, color: Colors.grey),
                              ),
                              // Inside your itemBuilder method where you build the comment icon
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
                                          imagePath: imageList[index]['firstImageUrl'],
                                          imagePath2: imageList[index]['secondImageUrl'],
                                          workoutSessionId: imageList[index]['workoutSessionId'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.comment, color: Colors.grey),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                StreamBuilder<Post>(
                  stream: friendsPostStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final post = snapshot.data!;
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              children: [
                                Text(post.caption),
                                Image.network(
                                  post.firstImageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                Image.network(
                                  post.secondImageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}