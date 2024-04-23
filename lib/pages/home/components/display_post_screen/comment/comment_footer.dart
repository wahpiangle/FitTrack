import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class CommentFooter extends StatefulWidget {
  final Post post;
  final Function resetComments;
  const CommentFooter({
    super.key,
    required this.post,
    required this.resetComments,
  });

  @override
  State<CommentFooter> createState() => _CommentFooterState();
}

class _CommentFooterState extends State<CommentFooter> {
  final commentTextController = TextEditingController();

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

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
              child: TextField(
                controller: commentTextController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
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
                  FirebaseCommentService.addCommentToPost(
                    widget.post.postId,
                    commentTextController.text,
                  );
                  widget.resetComments();
                  commentTextController.text = '';
                } catch (e) {
                  commentTextController.text = '';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error adding comment to post: $e'),
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
