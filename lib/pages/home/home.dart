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
  late final bool? showCursor;
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
                          radius: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'User_123456789',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    PopupMenuButton(
                      color:  const Color(0xFF1A1A1A), // Set the background color of the dropdown menu
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white), // Set the text color
                          ),
                          value: 'delete',
                        ),
                        PopupMenuItem(
                          child: Text(
                            'Report Post',
                            style: TextStyle(color: Colors.red), // Set the text color
                          ),
                          value: 'report',
                        ),
                      ],
                      onSelected: (value) {
                        // Handle item selection here
                        if (value == 'delete') {
                          // Perform delete action
                        } else if (value == 'report') {
                          // Perform report action
                        }
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),


                  ],
                ),
              SizedBox(height: 2), // Reduce the vertical space here
              // Add some space between user info and carousel
              SizedBox(
                child: CarouselSlider.builder(
                  itemCount: imageList.length,
                  options: CarouselOptions(
                    aspectRatio: 0.9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    enlargeFactor: 0.2,
                    viewportFraction: 0.6,
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
                              : Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              showCursor: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                              enableInteractiveSelection: false, // Disables cursor and text selection
                              decoration: InputDecoration(
                                alignLabelWithHint: true, // Align the label with the hint
                                hintText: 'Add a caption..',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 16), // Adjust left padding
                              ),
                              // Add your caption input logic here
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // TODO: Display friend's posts
            ],
          ),
        ),
      ),
    );
  }
}
