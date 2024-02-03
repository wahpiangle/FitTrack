import 'dart:io';

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
        ColorFiltered(
          colorFilter: uploadError || isLoading
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
            colorFilter: uploadError || isLoading
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
      ],
    );
  }
}
