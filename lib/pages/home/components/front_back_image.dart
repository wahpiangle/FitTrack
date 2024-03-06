import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FrontBackImage extends StatelessWidget {
  final String firstImageUrl;
  final String secondImageUrl;
  final bool uploadError;
  final bool isLoading;

  const FrontBackImage({
    super.key,
    required this.firstImageUrl,
    required this.secondImageUrl,
    this.uploadError = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        getImageBasedonType(firstImageUrl, false),
        Container(
          margin: const EdgeInsets.only(
            left: 5,
            top: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: getImageBasedonType(secondImageUrl, true),
        ),
      ],
    );
  }
}

Widget getImageBasedonType(String image, bool secondImage) {
  if (image.contains("http://") || image.contains("https://")) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      width: secondImage ? 50 : null,
      imageUrl: image,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  } else {
    return Image.file(
      File(image),
      fit: BoxFit.fill,
      width: secondImage ? 50 : null,
    );
  }
}
