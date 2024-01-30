import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/camera_controls.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/capturing_loader.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/first_image_loader.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/display_image_scren.dart';

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
  bool isCapturingImage = false;
  XFile? firstImageState;
  XFile? secondImageState;

  @override
  void initState() {
    super.initState();
    flashMode = FlashMode.off;
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    _controller.setFlashMode(flashMode);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleCameraLens(bool resetState) {
    final nextCamera =
        _controller.description.lensDirection == CameraLensDirection.front
            ? widget.cameras
                .firstWhere((c) => c.lensDirection == CameraLensDirection.back)
            : widget.cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.front,
                orElse: () => widget.cameras.first);

    _controller = CameraController(
      nextCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();

    if (resetState) {
      setState(() {});
    }
  }

  void toggleCameraFlash() {
    setState(() {
      if (flashMode == FlashMode.off) {
        flashMode = FlashMode.always;
      } else if (flashMode == FlashMode.always) {
        flashMode = FlashMode.auto;
      } else {
        flashMode = FlashMode.off;
      }
      _controller.setFlashMode(flashMode);
    });
  }

  void takePicture() async {
    setState(() {
      isCapturingImage = true;
    });
    await _initializeControllerFuture;

    final firstImage = await _controller.takePicture();
    setState(() {
      firstImageState = firstImage;
    });

    toggleCameraLens(false);
    await _initializeControllerFuture;

    final secondImage = await _controller.takePicture();
    setState(() {
      secondImageState = secondImage;
    });
    if (!mounted) return;

    setState(() {
      isCapturingImage = false;
      _controller = CameraController(
        widget.cameras.first,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
      _controller.setFlashMode(flashMode);
    });
  }

  void toggleRetake() {
    setState(() {
      firstImageState = null;
      secondImageState = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(flashMode);
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
          if (firstImageState != null && secondImageState != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                children: [
                  DisplayImageScreen(
                    toggleRetake: toggleRetake,
                    imagePath: firstImageState!.path,
                    imagePath2: secondImageState!.path,
                  ),
                ],
              ),
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
                    child: isCapturingImage
                        ? firstImageState == null
                            ? const CapturingLoader()
                            : FirstImageLoader(
                                firstImageState: firstImageState!)
                        : snapshot.connectionState == ConnectionState.done
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CameraPreview(_controller),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.65,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
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