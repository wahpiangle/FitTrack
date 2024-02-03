import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/display_image_stack.dart';
import 'package:group_project/constants/themes/app_colours.dart';

class Home extends StatefulWidget {
  final bool? success;
  const Home({
    super.key,
    this.success,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current = 0;
  final UploadImageProvider uploadImageProvider = UploadImageProvider();
  final List<Map<String, String>> imageList =
      objectBox.postService.getPosts().asMap().entries.map((entry) {
    final item = entry.value;
    return {
      'firstImageUrl': item.firstImageUrl,
      'secondImageUrl': item.secondImageUrl,
    };
  }).toList();

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imageList.map((entry) {
      final firstImage = entry['firstImageUrl']!;
      final secondImage = entry['secondImageUrl']!;
      final index = imageList.indexOf(entry);

      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: index == _current
            ? DisplayImageStack(
                firstImageUrl: firstImage,
                secondImageUrl: secondImage,
              )
            : ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
                child: DisplayImageStack(
                  firstImageUrl: firstImage,
                  secondImageUrl: secondImage,
                ),
              ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppColours.primary,
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            FutureBuilder<bool>(
              future: uploadImageProvider.getUploadError(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final uploadError = snapshot.data!;
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 1.8,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            enlargeFactor: 0.3,
                            scrollPhysics: uploadError
                                ? const NeverScrollableScrollPhysics()
                                : null,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: imageSliders,
                        ),
                      ),
                      uploadError
                          ? const Text(
                              'There was an error uploading your workout. Please try again.',
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            )
                          : imageSliders.isEmpty
                              ? Container()
                              : const Text(
                                  'Add a caption',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                    ],
                  );
                } else {
                  return CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1.8,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      enlargeFactor: 0.3,
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: imageSliders,
                  );
                }
              },
            ),
            // TODO: posts from friends
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          objectBox.postService.test();
          uploadImageProvider.setUploadError(false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
