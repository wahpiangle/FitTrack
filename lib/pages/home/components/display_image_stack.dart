import 'package:flutter/material.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/front_back_image.dart';

class DisplayImageStack extends StatelessWidget {
  final String firstImageUrl;
  final String secondImageUrl;
  const DisplayImageStack({
    super.key,
    required this.firstImageUrl,
    required this.secondImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UploadImageProvider().getUploadError(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final bool uploadError = snapshot.data!;
          return GestureDetector(
            onTap: () {
              print('ola');
            },
            child: Stack(
              children: [
                FrontBackImage(
                    firstImageUrl: firstImageUrl,
                    secondImageUrl: secondImageUrl,
                    uploadError: uploadError),
                uploadError
                    ? const Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.replay_outlined,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
        } else {
          return Stack(
            children: [
              FrontBackImage(
                firstImageUrl: firstImageUrl,
                secondImageUrl: secondImageUrl,
                isLoading: true,
              ),
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
