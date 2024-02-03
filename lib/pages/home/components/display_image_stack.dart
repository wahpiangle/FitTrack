import 'dart:io';

import 'package:flutter/material.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:provider/provider.dart';

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
    final UploadImageProvider uploadImageProvider =
        Provider.of<UploadImageProvider>(context);
    return GestureDetector(
      onTap: () {
        print('ola');
      },
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: uploadImageProvider.uploadError
                ? ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  )
                : const ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.srcOver,
                  ),
            child: Image.file(
              File(firstImageUrl),
              fit: BoxFit.fill,
            ),
          ),
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
            child: ColorFiltered(
              colorFilter: uploadImageProvider.uploadError
                  ? ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    )
                  : const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.srcOver,
                    ),
              child: Image.file(
                File(secondImageUrl),
                fit: BoxFit.fill,
                width: 50,
              ),
            ),
          ),
          const Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.replay_outlined,
                color: Colors.red,
                size: 40,
              ),
            ),
          )
        ],
      ),
    );
  }
}
