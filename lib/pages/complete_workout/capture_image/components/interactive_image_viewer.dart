import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InteractiveImageViewer extends StatefulWidget {
  final Function? toggleRetake;
  final String imagePath;
  final String imagePath2;
  final Function? disableScroll;
  final Function? enableScroll;
  final Function? disableHorizontalScroll;
  final Function? enableHorizontalScroll;
  const InteractiveImageViewer({
    super.key,
    this.toggleRetake,
    required this.imagePath,
    required this.imagePath2,
    this.disableScroll,
    this.enableScroll,
    this.disableHorizontalScroll,
    this.enableHorizontalScroll,
  });

  @override
  State<InteractiveImageViewer> createState() => _InteractiveImageViewerState();
}

class _InteractiveImageViewerState extends State<InteractiveImageViewer> {
  double xOffset = 20.0;
  double yOffset = 20.0;
  bool displaySecondImage = false;
  bool hideSecondImage = false;
  final TransformationController _transformationController =
      TransformationController();
  Matrix4 initialControllerValue = Matrix4.identity();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: InteractiveViewer(
            transformationController: _transformationController,
            onInteractionStart: (ScaleStartDetails details) {
              if (widget.disableScroll != null) {
                widget.disableScroll!();
              }
              initialControllerValue = _transformationController.value;
              setState(() {
                hideSecondImage = true;
              });
            },
            scaleEnabled: true,
            onInteractionEnd: (ScaleEndDetails details) {
              _transformationController.value = initialControllerValue;
              if (widget.enableScroll != null) {
                widget.enableScroll!();
              }
              setState(() {
                hideSecondImage = false;
              });
            },
            child: getImageBasedonType(
              widget.imagePath,
              true,
              displaySecondImage,
              widget.imagePath,
              widget.imagePath2,
              context,
            ),
          ),
        ),
        widget.toggleRetake == null
            ? Container()
            : Positioned(
                top: 5,
                left: 5,
                child: IconButton(
                  onPressed: () {
                    widget.toggleRetake!();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
        Positioned(
          left: xOffset,
          top: yOffset,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.vibrate();
              setState(() {
                displaySecondImage = !displaySecondImage;
              });
            },
            onTapDown: (details) {
              if (widget.disableScroll != null) {
                widget.disableScroll!();
                widget.disableHorizontalScroll!();
              }
            },

            onPanUpdate: (details) {
              if (widget.disableScroll != null) {
                widget.disableScroll!();
              }
              setState(() {
                xOffset += details.delta.dx * 1;
                yOffset += details.delta.dy * 1;

                xOffset =
                    xOffset.clamp(20, MediaQuery.of(context).size.width * 0.62);
                yOffset =
                    yOffset.clamp(20, MediaQuery.of(context).size.height * 0.4);
              });
            },
            onPanEnd: (details) {
              if (widget.enableScroll != null) {
                widget.enableScroll!();
                widget.enableHorizontalScroll!();
              }
              if (xOffset > MediaQuery.of(context).size.width * 0.62 / 2) {
                setState(() {
                  xOffset = MediaQuery.of(context).size.width * 0.62;
                });
              } else {
                setState(() {
                  xOffset = 20;
                });
              }
              if (yOffset > MediaQuery.of(context).size.height * 0.4 / 2) {
                setState(() {
                  yOffset = MediaQuery.of(context).size.height * 0.4;
                });
              } else {
                setState(() {
                  yOffset = 20;
                });
              }
            },
            child: hideSecondImage
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: getImageBasedonType(
                        widget.imagePath,
                        false,
                        displaySecondImage,
                        widget.imagePath2,
                        widget.imagePath,
                        context,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

Widget getImageBasedonType(
    String image,
    bool isMainImage,
    bool displaySecondImage,
    String imagePath,
    String imagePath2,
    BuildContext context) {
  if (image.contains("http://") || image.contains("https://")) {
    return CachedNetworkImage(
      imageUrl: displaySecondImage ? imagePath2 : imagePath,
      width: MediaQuery.of(context).size.width * (isMainImage ? 1 : 0.25),
      fit: BoxFit.contain,
      placeholder: (context, url) => const SizedBox(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  } else {
    return Image.file(
      File(
        displaySecondImage ? imagePath2 : imagePath,
      ),
      width: MediaQuery.of(context).size.width * (isMainImage ? 1 : 0.25),
      fit: isMainImage ? BoxFit.cover : BoxFit.fill,
    );
  }
}
