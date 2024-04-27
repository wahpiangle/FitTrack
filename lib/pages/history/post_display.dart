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
import 'package:group_project/pages/home/components/display_post_screen/comment/comment_tile.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_reaction_image.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class PostDisplay extends StatefulWidget {
  final FirebaseUser? posterInfo;
  final String postId;
  final DateTime postDate;

  const PostDisplay({
    super.key,
    this.posterInfo,
    required this.postId,
    required this.postDate,
  });

  @override
  State<PostDisplay> createState() => _PostDisplay();
}

class _PostDisplay extends State<PostDisplay> {
  int _pointerCount = 0;
  late Future<Post?> _postFuture;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _commentStream;
  late Future<List<Reaction>> _reactionFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = FirebasePostsService.getPostById(widget.postId);
    _commentStream = FirebaseCommentService.getCommentStreamById(widget.postId);
    _reactionFuture = FirebasePostsService.getReactionsByPostId(widget.postId);
  }

  void disableScroll() {
    setState(() {});
  }

  void enableScroll() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColours.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Column(
          children: [
            const Text(
              'Your memories',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('EEEE, dd MMMM yyyy, hh:mm:ss a').format(
                widget.postDate,
              ),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
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
            child: Container(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                physics: _pointerCount == 2
                    ? const NeverScrollableScrollPhysics()
                    : null,
                child: Column(
                  children: [
                    FutureBuilder<Post?>(
                      future: _postFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Text('Error fetching post data');
                        }
                        final post = snapshot.data!;
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: PageView(
                            pageSnapping: true,
                            scrollDirection: Axis.horizontal,
                            controller: PageController(),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: InteractiveImageViewer(
                                  imagePath: post.firstImageUrl,
                                  imagePath2: post.secondImageUrl,
                                  disableScroll: disableScroll,
                                  enableScroll: enableScroll,
                                ),
                              ),
                              // Add more image widgets if needed
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<Post?>(
                      future: _postFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Text('Error fetching post data');
                        }
                        final post = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            post.caption.isNotEmpty ? post.caption : '......',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      color: AppColours.primaryBright,
                      thickness: 1,
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FutureBuilder<List<Reaction>>(
                            future: _reactionFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return const Text('Error fetching reactions');
                              }
                              final reactions = snapshot.data ?? [];
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: reactions.map((reaction) {
                                    return DisplayPostReactionImage(
                                      reaction: reaction,
                                      fullReactionList: reactions,
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: AppColours.primaryBright,
                      thickness: 1,
                      height: 30,
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _commentStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return const Text('Error fetching comments');
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text('No comments');
                        }
                        return Column(
                          children: snapshot.data!.docs.map((doc) {
                            final Comment comment = Comment.fromDocument(doc);
                            return GestureDetector(
                              onLongPress: () {
                                if (comment.postedBy ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid ||
                                    widget.postId ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                  HapticFeedback.heavyImpact();
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
      ),
    );
  }
}
