import 'package:flutter/widgets.dart';

class MyClipperPath extends CustomClipper<Path> {
  MyClipperPath();

  @override
  Path getClip(Size size) {
    Path path = Path();

    //get only the first half of width of image
    path.lineTo(0, 0);
    path.lineTo(size.width / 2, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
