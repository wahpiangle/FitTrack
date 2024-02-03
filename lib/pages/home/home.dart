import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/image_carousel.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final bool? success;
  const Home({
    super.key,
    this.success,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final UploadImageProvider uploadImageProvider =
        Provider.of<UploadImageProvider>(context);
    return Scaffold(
      backgroundColor: AppColours.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ImageCarousel(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                uploadImageProvider.uploadError
                    ? 'Upload failed. Click to try again.'
                    : 'Add a caption...',
                style: TextStyle(
                  color: uploadImageProvider.uploadError
                      ? Colors.red
                      : Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadImageProvider.test();
          objectBox.postService.test();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
