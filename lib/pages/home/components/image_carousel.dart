import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/home/components/display_image_stack.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _current = 0;
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
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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

    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 1.8,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        enlargeFactor: 0.3,
        viewportFraction: 0.4,
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
      items: imageSliders,
    );
  }
}
