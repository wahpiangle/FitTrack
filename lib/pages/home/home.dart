import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/display_image_stack.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current = 0;
  final List<Map<String, String>> imageList =
      objectBox.postService.getActivePosts().asMap().entries.map((entry) {
    final item = entry.value;
    return {
      'firstImageUrl': item.firstImageUrl,
      'secondImageUrl': item.secondImageUrl,
    };
  }).toList();

  @override
  void initState() {
    super.initState();
    context.read<UploadImageProvider>().getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final UploadImageProvider uploadImageProvider =
        context.watch<UploadImageProvider>();
    return Scaffold(
      backgroundColor: AppColours.primary,
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              child: CarouselSlider.builder(
                  itemCount: imageList.length,
                  options: CarouselOptions(
                    aspectRatio: 0.9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    enlargeFactor: 0.1,
                    viewportFraction: 0.45,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final firstImage = imageList[index]['firstImageUrl']!;
                    final secondImage = imageList[index]['secondImageUrl']!;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
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
                        ],
                      ),
                    );
                  }),
            ),
            // TODO: Display friend's posts
          ],
        ),
      ),
    );
  }
}
