import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/models/post.dart';

class FrontBackImage extends StatelessWidget {
  final Post post;

  const FrontBackImage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        getImageBasedonType(post.firstImageUrl, false),
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
          child: getImageBasedonType(post.secondImageUrl, true),
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
      placeholder: (context, url) => const SizedBox(
        height: 50,
        width: 50,
      ),
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
