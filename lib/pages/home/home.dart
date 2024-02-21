import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/upload_enums.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/display_image_stack.dart';
import 'package:group_project/constants/themes/app_colours.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<UploadImageProvider>().getSharedPreferences();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool(UploadEnums.isUploading) == true) {
        // Handle the case where the app was force quit during upload
        context.read<UploadImageProvider>().setUploadError(true);
        context.read<UploadImageProvider>().setIsUploading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final UploadImageProvider uploadImageProvider =
    context.watch<UploadImageProvider>();
    bool hasImages = imageList.isNotEmpty; // Check if there are images

    return Scaffold(
      backgroundColor: AppColours.primary,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              // Add space above the carousel
              // Display user info if there are images
              if (hasImages)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                          AssetImage('assets/icons/defaultimage.jpg'),
                          // Add path to profile image
                          radius: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'User_123456789', // Add the username
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        // Add your action here when the three dots icon is pressed
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10),
              // Add some space between user info and carousel
              CarouselSlider.builder(
                itemCount: imageList.length,
                options: CarouselOptions(
                  aspectRatio: 0.9,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  enlargeFactor: 0.2, // Adjust the enlargeFactor to increase the size
                  viewportFraction: 0.9, // Adjust the viewportFraction for larger images
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),

                itemBuilder: (context, index, realIndex) {
                  final firstImage = imageList[index]['firstImageUrl']!;
                  final secondImage = imageList[index]['secondImageUrl']!;
                  final postId = imageList[index]['postId']!;
                  final workoutSessionId =
                  imageList[index]['workoutSessionId']!;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
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
                            : const Text(
                          // todo: allow user to add a caption to their post
                          'Add a caption',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFF333333),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1, // Adjust flex to make TextField smaller
                                child: TextField(
                                  style: TextStyle(color: Colors.white), // Text color
                                  decoration: InputDecoration(
                                    prefix: SizedBox(width: 10),
                                    hintText: 'Add a comment...',
                                    hintStyle: TextStyle(color: Colors.grey), // Hint color
                                    border: InputBorder.none,
                                  ),
                                  // Handle comment logic
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle submit comment
                                },
                                icon: Icon(Icons.send),
                                color: Colors.white, // Send button color
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                },
              ),

              // TODO: Display friend's posts
            ],
          ),
        ),
      ),
    );
  }
}
