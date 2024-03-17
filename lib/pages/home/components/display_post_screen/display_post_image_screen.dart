import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';
import 'package:group_project/pages/home/components/display_post_screen/comment/comment_footer.dart';
import 'package:group_project/pages/home/components/display_post_screen/comment/comment_tile.dart';
import 'package:group_project/pages/home/components/display_post_screen/comment/delete_comment_dialog.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_reaction_image.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_workout_info_screen.dart';
import 'package:group_project/pages/home/components/display_post_screen/edit_caption_page.dart';
import 'package:group_project/services/firebase/auth_service.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class DisplayPostImageScreen extends StatefulWidget {
  final Post post;
  final List<Reaction> reactions;
  final FirebaseUser? posterInfo;

  const DisplayPostImageScreen({
    super.key,
    required this.post,
    required this.reactions,
    this.posterInfo,
  });

  @override
  State<DisplayPostImageScreen> createState() => _DisplayPostImageScreenState();
}

class _DisplayPostImageScreenState extends State<DisplayPostImageScreen> {
  int _pointerCount = 0;
  Stream<QuerySnapshot>? _commentStream;

  @override
  void initState() {
    super.initState();
    _commentStream =
        FirebaseCommentService.getCommentStreamById(widget.post.postId);
  }

  @override
  Widget build(BuildContext context) {
    final isOwnPost =
        AuthService().getCurrentUser()!.uid == widget.post.postedBy;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Text(
                isOwnPost
                    ? 'My Post'
                    : '${widget.posterInfo?.username}\'s Post',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat('EEEE, hh:mm:ss a').format(widget.post.date),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          backgroundColor: AppColours.primary,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayPostWorkoutInfoScreen(
                        post: widget.post,
                        posterInfo: widget.posterInfo,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.fitness_center_sharp,
                  color: AppColours.secondary,
                ))
          ],
        ),
        backgroundColor: AppColours.primary,
        body: Listener(
          onPointerDown: (event) {
            setState(() {
              _pointerCount++;
            });
          },
          onPointerUp: (event) {
            setState(() {
              _pointerCount--;
            });
          },
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: FooterLayout(
              footer: CommentFooter(post: widget.post),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  physics: _pointerCount == 2
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  child: Column(
                    children: [
                      // TODO: Make the image viewer a carousel
                      InteractiveImageViewer(
                        imagePath: widget.post.firstImageUrl,
                        imagePath2: widget.post.secondImageUrl,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            if (widget.post.postedBy ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCaptionPage(
                                    post: widget.post,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            widget.post.caption == '' &&
                                    widget.post.postedBy ==
                                        FirebaseAuth.instance.currentUser!.uid
                                ? 'Add a caption...'
                                : widget.post.caption,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: AppColours.primaryBright,
                        thickness: 1,
                        height: 30,
                      ),
                      SingleChildScrollView(
                        child: Row(
                          children: widget.reactions.map((reaction) {
                            return DisplayPostReactionImage(
                              reaction: reaction,
                              fullReactionList: widget.reactions,
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(
                        color: AppColours.primaryBright,
                        thickness: 1,
                        height: 30,
                      ),
                      StreamBuilder(
                        stream: _commentStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Error fetching comments'),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text('No comments'),
                            );
                          }
                          return Column(
                            children: snapshot.data!.docs.map((doc) {
                              final Comment comment = Comment.fromDocument(doc);
                              return GestureDetector(
                                onLongPress: () {
                                  if (comment.postedBy ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid ||
                                      widget.post.postedBy ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid) {
                                    HapticFeedback.heavyImpact();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DeleteCommentDialog(
                                          comment: comment,
                                          post: widget.post,
                                        );
                                      },
                                    );
                                  }
                                },
                                child: CommentTile(
                                  comment: comment,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
