import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';
import 'package:group_project/pages/home/components/display_post_screen/comment/comment_footer.dart';
import 'package:group_project/pages/home/components/display_post_screen/comment/comment_tile.dart';
import 'package:group_project/pages/home/components/display_post_screen/comment/delete_comment_dialog.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_reaction_image.dart';
import 'package:group_project/pages/home/components/display_post_screen/workout_info/display_post_workout_info_screen.dart';
import 'package:group_project/pages/home/components/display_post_screen/edit_caption_page.dart';
import 'package:group_project/services/firebase/auth_service.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class DisplayPostImageScreen extends StatefulWidget {
  final FirebaseUser? posterInfo;
  final List<FirebaseUserPost> firebaseUserPosts;
  final int index;

  const DisplayPostImageScreen({
    super.key,
    this.posterInfo,
    this.index = 0,
    required this.firebaseUserPosts,
  });

  @override
  State<DisplayPostImageScreen> createState() => _DisplayPostImageScreenState();
}

class _DisplayPostImageScreenState extends State<DisplayPostImageScreen> {
  int _pointerCount = 0;
  bool _isScrollDisabled = false;
  int _streamIndex = 0;
  List<Stream<QuerySnapshot<Map<String, dynamic>>>>? _commentStreams;
  late PageController controller;

  List<FirebaseUserPost> filterPostsByLast24Hours(
      List<FirebaseUserPost> posts) {
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    return posts.where((post) => post.post.date.isAfter(yesterday)).toList();
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
    _streamIndex = widget.index;
    _commentStreams = widget.firebaseUserPosts.map((currentUserPost) {
      return FirebaseCommentService.getCommentStreamById(
          currentUserPost.post.postId);
    }).toList();
  }

  void disableScroll() {
    setState(() {
      _isScrollDisabled = true;
    });
  }

  void enableScroll() {
    setState(() {
      _isScrollDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOwnPost = AuthService().getCurrentUser()!.uid ==
        widget.firebaseUserPosts[_streamIndex].postedBy.uid;
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
                DateFormat('EEEE, dd MMMM yyyy, hh:mm:ss a')
                    .format(widget.firebaseUserPosts[_streamIndex].post.date),
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
                        post: widget.firebaseUserPosts[_streamIndex].post,
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
              footer: CommentFooter(
                  post: widget.firebaseUserPosts[_streamIndex].post,
                  resetComments: () {
                    setState(() {
                      _commentStreams =
                          widget.firebaseUserPosts.map((currentUserPost) {
                        return FirebaseCommentService.getCommentStreamById(
                            currentUserPost.post.postId);
                      }).toList();
                    });
                  }),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  physics: _pointerCount == 2 || _isScrollDisabled
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: PageView.builder(
                          pageSnapping: true,
                          scrollDirection: Axis.horizontal,
                          physics: _isScrollDisabled
                              ? const NeverScrollableScrollPhysics()
                              : null,
                          itemCount: widget.firebaseUserPosts.length,
                          controller: controller,
                          onPageChanged: (index) {
                            setState(() {
                              _streamIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: InteractiveImageViewer(
                                imagePath: widget.firebaseUserPosts[index].post
                                    .firstImageUrl,
                                imagePath2: widget.firebaseUserPosts[index].post
                                    .secondImageUrl,
                                disableScroll: disableScroll,
                                enableScroll: enableScroll,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            if (widget.firebaseUserPosts[_streamIndex].post
                                    .postedBy ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCaptionPage(
                                    post: widget
                                        .firebaseUserPosts[_streamIndex].post,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            widget.firebaseUserPosts[_streamIndex].post
                                            .caption ==
                                        '' &&
                                    widget.firebaseUserPosts[_streamIndex].post
                                            .postedBy ==
                                        FirebaseAuth.instance.currentUser!.uid
                                ? 'Add a caption...'
                                : widget.firebaseUserPosts[_streamIndex].post
                                    .caption,
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
                          children: widget
                              .firebaseUserPosts[_streamIndex].reactions
                              .map((reaction) {
                            return DisplayPostReactionImage(
                              reaction: reaction,
                              fullReactionList: widget
                                  .firebaseUserPosts[_streamIndex].reactions,
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
                        stream: _commentStreams![_streamIndex],
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
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Comment comment = Comment.fromDocument(
                                  snapshot.data!.docs[index],
                                );
                                return GestureDetector(
                                  onLongPress: () {
                                    if (comment.postedBy ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid ||
                                        widget.firebaseUserPosts[_streamIndex]
                                                .post.postedBy ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid) {
                                      HapticFeedback.heavyImpact();
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DeleteCommentDialog(
                                            toggleState: () {
                                              setState(() {
                                                _commentStreams = widget
                                                    .firebaseUserPosts
                                                    .map((currentUserPost) {
                                                  return FirebaseCommentService
                                                      .getCommentStreamById(
                                                          currentUserPost
                                                              .post.postId);
                                                }).toList();
                                                _pointerCount = 0;
                                              });
                                            },
                                            comment: comment,
                                            post: widget
                                                .firebaseUserPosts[_streamIndex]
                                                .post,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: CommentTile(
                                    comment: comment,
                                  ),
                                );
                              });
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
