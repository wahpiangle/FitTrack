import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/home/components/display_post_screen/caption_footer.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class EditCaptionPage extends StatelessWidget {
  final Post post;
  const EditCaptionPage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        title: const Text(
          'Edit Caption',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FooterLayout(
        footer: CaptionFooter(
          post: post,
        ),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: post.firstImageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 5,
                    top: 5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: post.secondImageUrl,
                    width: 50,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post.caption,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
