import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DisplayImageScreen extends StatefulWidget {
  final Function toggleRetake;
  final String imagePath;
  final String imagePath2;

  const DisplayImageScreen({
    super.key,
    required this.toggleRetake,
    required this.imagePath,
    required this.imagePath2,
  });

  @override
  State<DisplayImageScreen> createState() => _DisplayImageScreenState();
}

class _DisplayImageScreenState extends State<DisplayImageScreen>
    with TickerProviderStateMixin {
  double xOffset = 30.0;
  double yOffset = 30.0;
  bool displaySecondImage = false;
  bool hideSecondImage = false;
  final TransformationController _transformationController =
      TransformationController();
  Matrix4 initialControllerValue = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InteractiveViewer(
                transformationController: _transformationController,
                onInteractionStart: (ScaleStartDetails details) {
                  initialControllerValue = _transformationController.value;
                  setState(() {
                    hideSecondImage = true;
                  });
                },
                onInteractionEnd: (ScaleEndDetails details) {
                  _transformationController.value = initialControllerValue;
                  setState(() {
                    hideSecondImage = false;
                  });
                },
                child: Image.file(
                  File(
                    displaySecondImage ? widget.imagePath2 : widget.imagePath,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.65,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: IconButton(
                onPressed: () {
                  widget.toggleRetake();
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
                onPanUpdate: (details) {
                  setState(() {
                    xOffset += details.delta.dx * 1.5;
                    yOffset += details.delta.dy * 1.5;

                    xOffset = xOffset.clamp(
                        20, MediaQuery.of(context).size.width * 0.6);
                    yOffset = yOffset.clamp(
                        20, MediaQuery.of(context).size.height * 0.45 - 20);
                  });
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
                          child: Image.file(
                            File(
                              displaySecondImage
                                  ? widget.imagePath
                                  : widget.imagePath2,
                            ),
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.25,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.send,
              color: Colors.white,
              size: 30,
            ),
            label: const Text(
              'Send',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            )),
      ],
    );
  }
}
