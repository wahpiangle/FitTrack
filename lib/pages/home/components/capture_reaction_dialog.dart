import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';

class CaptureReactionDialog extends StatefulWidget {
  final ValueNotifier<Offset> pointerPosition;
  final Post post;

  const CaptureReactionDialog({
    super.key,
    required this.pointerPosition,
    required this.post,
  });

  @override
  State<CaptureReactionDialog> createState() => _CaptureReactionDialogState();
}

class _CaptureReactionDialogState extends State<CaptureReactionDialog> {
  late List<CameraDescription> cameras;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isPointerInRect = false;

  @override
  void dispose() async {
    if (isPointerInRect) {
      await _takePicture();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getCameras();
    });

    super.initState();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile file = await _controller.takePicture();
      await FirebasePostsService.addReactionToPost(
        file.path,
        widget.post,
      );
    } catch (e) {
      print(e);
    }
  }

  _getCameras() async {
    final cameras = await availableCameras();
    setState(() {
      this.cameras = cameras;
    });
    setState(() {
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );
    });
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    Rect rectangle = Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2 - 100,
      ),
      width: 300,
      height: 300,
    );
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: ValueListenableBuilder(
          valueListenable: widget.pointerPosition,
          builder: (context, value, child) {
            final double pointerX = value.dx;
            final double pointerY = value.dy;

            isPointerInRect = rectangle.contains(Offset(pointerX, pointerY));
            return SafeArea(
              child: Stack(children: [
                const Positioned.fill(
                  top: 20,
                  child: Column(
                    children: [
                      Text(
                        'React to your friend\'s post!',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          decoration: TextDecoration.none,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Slide and release to send\nRelease now to cancel',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Positioned.fromRect(
                  rect: rectangle,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isPointerInRect ? Colors.white : Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(300),
                    ),
                    child: child!,
                  ),
                ),
                Positioned(
                  left: pointerX - 20,
                  top: pointerY - 20,
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        color: Colors.grey[300]?.withOpacity(0.2),
                      )),
                ),
              ]),
            );
          },
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: CameraPreview(_controller));
              } else {
                return const CircularProgressIndicator();
              }
            },
          )),
    );
  }
}
