import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/home/components/display_post_image_screen.dart';
import 'package:group_project/pages/home/components/front_back_image.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:provider/provider.dart';

class DisplayImageStack extends StatelessWidget {
  final Post post;
  final int index;
  final int current;
  final int objectBoxPostId;

  const DisplayImageStack({
    super.key,
    required this.post,
    required this.index,
    required this.current,
    required this.objectBoxPostId,
  });

  @override
  Widget build(BuildContext context) {
    final UploadImageProvider uploadImageProvider =
        context.watch<UploadImageProvider>();
    final bool uploading = uploadImageProvider.uploading;
    final bool uploadError = uploadImageProvider.uploadError;
    return GestureDetector(
      onTap: () {
        if (uploadError) {
          uploadImageProvider.reset();
          FirebasePostsService.createPost(
            objectBox.postService.getPost(objectBoxPostId)!,
            context.read<UploadImageProvider>(),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DisplayPostImageScreen(
                post: post,
              ),
            ),
          );
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              ColorFiltered(
                colorFilter: uploadError || uploading || index != current
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      )
                    : const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.srcOver,
                      ),
                child: FrontBackImage(
                  post: post,
                  uploadError: uploadError,
                  isLoading: uploading,
                ),
              ),
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
                  : uploading && index == current
                      ? const Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
