import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FirstImageLoader extends StatelessWidget {
  final XFile firstImageState;
  const FirstImageLoader({
    super.key,
    required this.firstImageState,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          image: FileImage(
            File(firstImageState.path),
          ),
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Smile!.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ]);
  }
}
