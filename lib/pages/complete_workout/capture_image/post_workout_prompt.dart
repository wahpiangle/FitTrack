import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/camera_controls.dart';

class PostWorkoutPrompt extends StatefulWidget {
  final List<CameraDescription> cameras;
  const PostWorkoutPrompt({
    super.key,
    required this.cameras,
  });

  @override
  PostWorkoutPromptState createState() => PostWorkoutPromptState();
}

class PostWorkoutPromptState extends State<PostWorkoutPrompt> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late FlashMode flashMode;

  @override
  void initState() {
    super.initState();
    flashMode = FlashMode.off;
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleCameraLens() {
    if (widget.cameras.length == 1) {
      return;
    }

    final lensDirection = _controller.description.lensDirection;
    if (lensDirection == CameraLensDirection.front) {
      setState(() {
        _controller = CameraController(
          widget.cameras.firstWhere(
              (element) => element.lensDirection == CameraLensDirection.back),
          ResolutionPreset.medium,
        );
      });
    } else {
      setState(() {
        _controller = CameraController(
          widget.cameras.firstWhere(
              (element) => element.lensDirection == CameraLensDirection.front),
          ResolutionPreset.medium,
        );
      });
    }

    _initializeControllerFuture = _controller.initialize();
  }

  void toggleCameraFlash() {
    setState(() {
      if (flashMode == FlashMode.off) {
        flashMode = FlashMode.always;
        _controller.setFlashMode(flashMode);
      } else if (flashMode == FlashMode.always) {
        flashMode = FlashMode.auto;
        _controller.setFlashMode(flashMode);
      } else if (flashMode == FlashMode.auto) {
        flashMode = FlashMode.torch;
        _controller.setFlashMode(flashMode);
      } else {
        flashMode = FlashMode.off;
        _controller.setFlashMode(flashMode);
      }
    });
  }

  void takePicture() async {
    // TODO: take front pic then flip and take back pic
    await _initializeControllerFuture;
    final image = await _controller.takePicture();
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(
          imagePath: image.path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        title: const Text(
          'FitTrack',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColours.primary,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(_controller),
                    ),
                  ),
                ),
                CameraControls(
                  flashMode: flashMode,
                  toggleCameraLens: toggleCameraLens,
                  takePicture: takePicture,
                  toggleCameraFlash: toggleCameraFlash,
                )
              ],
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                CameraControls(
                  flashMode: flashMode,
                  toggleCameraLens: toggleCameraLens,
                  takePicture: takePicture,
                  toggleCameraFlash: toggleCameraFlash,
                )
              ],
            );
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
