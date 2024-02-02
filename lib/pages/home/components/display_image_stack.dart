import 'dart:io';

import 'package:flutter/material.dart';

class DisplayImageStack extends StatelessWidget {
  final String firstImageUrl;
  final String secondImageUrl;
  const DisplayImageStack({
    super.key,
    required this.firstImageUrl,
    required this.secondImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(
          File(firstImageUrl),
          fit: BoxFit.fill,
        ),
        Image.file(
          File(secondImageUrl),
          fit: BoxFit.fill,
          width: 50,
        ),
      ],
    );
  }
}
