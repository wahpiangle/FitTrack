import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';
import 'package:group_project/pages/home/components/display_post_screen/comment_footer.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_reaction_image.dart';
import 'package:group_project/pages/home/components/display_post_screen/edit_caption_page.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class DisplayPostImageScreen extends StatefulWidget {
  final Post post;
  final List<Reaction> reactions;

  const DisplayPostImageScreen({
    super.key,
    required this.post,
    required this.reactions,
  });

  @override
  State<DisplayPostImageScreen> createState() => _DisplayPostImageScreenState();
}

class _DisplayPostImageScreenState extends State<DisplayPostImageScreen> {
  int _pointersCount = 0;
  Stream<QuerySnapshot>? _commentStream;

  @override
  void initState() {
    super.initState();
    _commentStream =
        FirebaseCommentService.getCommentStreamById(widget.post.postId);
  }

  // TODO: display exercise details & comments
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              const Text(
                'My Post',
                style: TextStyle(
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
        ),
        backgroundColor: AppColours.primary,
        body: Listener(
          onPointerDown: (_) => setState(() => _pointersCount++),
          onPointerUp: (_) => setState(() => _pointersCount--),
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: FooterLayout(
              footer: CommentFooter(post: widget.post),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  physics: _pointersCount == 2
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
                                    // TODO: display delete comment dialog / menu anchor to ask to delete comment
                                  }
                                },
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    // TODO: display user profile image
                                    backgroundColor: AppColours.primaryBright,
                                    radius: 20,
                                  ),
                                  title: Row(
                                    children: [
                                      const Text(
                                        // TODO: display user name
                                        'display user name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        DateFormat.MMMMEEEEd()
                                            .format(comment.date),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    comment.comment,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
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
