import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/image_carousel.dart';
import 'package:provider/provider.dart';
import 'package:group_project/constants/themes/app_colours.dart';

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
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ImageCarousel(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          objectBox.postService.test();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
