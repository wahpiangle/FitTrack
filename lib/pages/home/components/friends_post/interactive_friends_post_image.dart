import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';
import 'package:group_project/pages/home/components/reaction/reaction_button.dart';
import 'package:group_project/pages/home/components/reaction/reaction_images.dart';

class InteractiveFriendsPostImage extends StatefulWidget {
  final FirebaseUserPost friendPostData;
  final void Function() toggleState;
  const InteractiveFriendsPostImage({
    super.key,
    required this.friendPostData,
    required this.toggleState,
  });

  @override
  State<InteractiveFriendsPostImage> createState() =>
      _InteractiveFriendsPostImageState();
}

class _InteractiveFriendsPostImageState
    extends State<InteractiveFriendsPostImage> {
  bool displayHoldInstruction = false;

  void showHoldInstruction() {
    setState(() {
      displayHoldInstruction = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        displayHoldInstruction = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            widget.friendPostData.post.firstImageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.friendPostData.post.secondImageUrl,
              fit: BoxFit.cover,
              width: 100,
            ),
          ),
        ),
        displayHoldInstruction
            ? Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: const Color(0xFF000000),
                  ),
                ),
              )
            : const SizedBox(),
        displayHoldInstruction
            ? const Positioned.fill(
                child: Center(
                  child: Text(
                    'Hold the emoji button to react',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        Positioned(
          bottom: 10,
          right: 10,
          child: Column(
            children: [
              ReactionButton(
                post: widget.friendPostData.post,
                showHoldInstruction: showHoldInstruction,
                toggleState: widget.toggleState,
              ),
            ],
          ),
        ),
        widget.friendPostData.reactions.isNotEmpty
            ? Positioned(
                bottom: 10,
                left: 10,
                child: ReactionImages(
                  postReactions: widget.friendPostData.reactions,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
