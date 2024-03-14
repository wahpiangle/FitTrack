import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class CaptionFooter extends StatefulWidget {
  final Post post;
  const CaptionFooter({
    super.key,
    required this.post,
  });

  @override
  State<CaptionFooter> createState() => _CaptionFooterState();
}

class _CaptionFooterState extends State<CaptionFooter> {
  String caption = '';
  @override
  Widget build(BuildContext context) {
    return KeyboardAttachable(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColours.primaryBright,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                autofocus: true,
                initialValue: widget.post.caption,
                onChanged: (value) {
                  setState(() {
                    caption = value;
                  });
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  hintText: 'Add a caption...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                try {
                  FirebasePostsService.saveCaption(
                    widget.post.postId,
                    caption,
                  );
                  widget.post.caption = caption;
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error adding caption to post: $e'),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
