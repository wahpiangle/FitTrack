import 'package:flutter/material.dart';

class ImageDisplay {
  static Widget buildUserProfileImage(String? imageUrl, {double radius = 22.0}) {
    bool isValidUrl = imageUrl != null && imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true;

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: AssetImage('assets/icons/defaultimage.jpg'),
          backgroundColor: Colors.transparent,
        ),
        if (isValidUrl)
          Positioned.fill(
            child: CircleAvatar(
              radius: radius,
              backgroundImage: NetworkImage(imageUrl!),
              backgroundColor: Colors.transparent,
            ),
          ),
      ],
    );
  }
}
