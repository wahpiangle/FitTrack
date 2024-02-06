import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';

class CameraControls extends StatelessWidget {
  final FlashMode flashMode;
  final Function(bool) toggleCameraLens;
  final Function toggleCameraFlash;
  final Function takePicture;

  const CameraControls({
    super.key,
    required this.flashMode,
    required this.toggleCameraLens,
    required this.toggleCameraFlash,
    required this.takePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: IconButton(
            onPressed: () {
              toggleCameraFlash();
            },
            icon: Icon(
              flashMode == FlashMode.off
                  ? Icons.flash_off
                  : flashMode == FlashMode.always
                      ? Icons.flash_on
                      : flashMode == FlashMode.auto
                          ? Icons.flash_auto
                          : Icons.flashlight_on,
              size: 30,
              color: AppColours.secondary,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: IconButton(
            onPressed: () async {
              try {
                takePicture();
              } catch (e) {
                print(e);
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColours.secondary),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(20),
              ),
            ),
            icon: const Icon(
              Icons.camera_alt,
              size: 40,
              color: AppColours.primary,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: IconButton(
            onPressed: () {
              toggleCameraLens(true);
            },
            icon: const Icon(
              Icons.flip_camera_ios,
              size: 30,
              color: AppColours.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
