import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerOptions extends StatelessWidget {
  final Future<void> Function(ImageSource) pickImage;
  const ImagePickerOptions({super.key, required this.pickImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
      color: AppColours.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppBar(
            backgroundColor: AppColours.primary,
            title: const Text('Choose an option',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.white)),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(AppColours.primaryBright),
              ),
              onPressed: () {
                pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.photo_library, color: Colors.white),
              label: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Pick from Gallery',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(AppColours.primaryBright),
              ),
              onPressed: () {
                pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Take a Picture',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
