import 'package:flutter/material.dart';

class ImageDisplay {
  static Widget buildUserProfileImage(String imageUrl) {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage('assets/icons/defaultimage.jpg'),
          backgroundColor: Colors.transparent,
        ),
        Positioned.fill(
          child: CircleAvatar(
            radius: 22,
            backgroundImage:  NetworkImage(imageUrl),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
