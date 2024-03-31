import 'package:flutter/material.dart';

class ImageDisplay {
  static Widget buildUserProfileImage(String? imageUrl, {double radius = 22.0, BuildContext? context}) {
    bool isValidUrl = imageUrl != null && imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true;

    return GestureDetector(
      onLongPress: () {
        if (context != null && isValidUrl) {
          _showFullImage(context, imageUrl);
        }
      },
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: const AssetImage('assets/icons/defaultimage.jpg'),
            backgroundColor: Colors.transparent,
          ),
          if (isValidUrl)
            Positioned.fill(
              child: CircleAvatar(
                radius: radius,
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }

  //when long press the profile image in user profile page, will show the full image
  static void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          panEnabled: false,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
