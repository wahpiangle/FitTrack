import 'package:flutter/material.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
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
    return Scaffold(
        body: Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<UploadImageProvider>().test();
          },
        ));
  }
}
