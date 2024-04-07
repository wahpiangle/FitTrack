import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';
import 'package:group_project/pages/home/components/display_post_screen/comment/comment_tile.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart';

class PostDisplay extends StatefulWidget {
  final String postId;
  final bool isVisible;

  const PostDisplay({
    super.key,
    required this.postId,
    required this.isVisible,
  });


  @override
  PostDisplayState createState() => PostDisplayState();
}

class PostDisplayState extends State<PostDisplay> {
  int _pointerCount = 0;
  bool _showComments = false;
  bool _isScrollDisabled = false;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          opacity: widget.isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Transform.translate(
            offset: widget.isVisible
                ? const Offset(0.0, 0.0)
                : const Offset(0.0, 50.0),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Your Memories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: widget.isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Transform.translate(
            offset: widget.isVisible
                ? const Offset(0.0, 0.0)
                : const Offset(0.0, 50.0),
            child: SingleChildScrollView(
              physics: _isScrollDisabled
                  ? const NeverScrollableScrollPhysics()
                  : null,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Listener(
                  onPointerDown: (event) {
                    setState(() {
                      _pointerCount++;
                      disableScroll();
                    });
                  },
                  onPointerUp: (event) {
                    setState(() {
                      _pointerCount--;
                      if (_pointerCount == 0) {
                        enableScroll();
                      }
                    });
                  },
                  child: FutureBuilder<Post?>(
                    future: _postFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final post = snapshot.data!;
                        return post.firstImageUrl.isNotEmpty ||
                                post.secondImageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    if (post.firstImageUrl.isNotEmpty)
                                      Positioned(
                                        top: 0,
                                        left: 5,
                                        right: 0,
                                          child: InteractiveImageViewer(
                                            imagePath: post.firstImageUrl,
                                            imagePath2: post.secondImageUrl,
                                            disableScroll: disableScroll,
                                            enableScroll: enableScroll,
                                          ),
                                      ),
                                    Positioned(
                                      bottom: 40,
                                      right: 5,
                                      child: FutureBuilder<List<Reaction>>(
                                        future: _reactionFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            final reactions = snapshot.data!;
                                            final reactionImageUrl =
                                                reactions.isNotEmpty
                                                    ? reactions[0].imageUrl
                                                    : '';
                                            return reactionImageUrl.isNotEmpty
                                                ? Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.black),
                                                    ),
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            reactionImageUrl,
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox();
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'No posts yet',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: widget.isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: FutureBuilder<Post?>(
            future: _postFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final post = snapshot.data!;
                return post.firstImageUrl.isNotEmpty ||
                        post.secondImageUrl.isNotEmpty
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            _showComments = !_showComments;
                          });
                        },
                        child: Text(
                          _showComments ? 'Hide Comments' : 'View Comments',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : const SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
        if (_showComments)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _commentStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final comments = snapshot.data?.docs;
                  if (comments == null || comments.isEmpty) {
                    return const Center(
                      child: Text(
                        'No comments available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final commentData = comments[index].data();
                        final comment = commentData['comment'] ?? '';
                        final postedBy = commentData['postedBy'] ?? '';
                        final date = commentData['date'];

                        return CommentTile(
                          comment: Comment(
                            id: '',
                            postId: widget.postId,
                            comment: comment,
                            postedBy: postedBy,
                            date: date != null
                                ? DateTime.fromMillisecondsSinceEpoch(
                                    date.seconds * 1000)
                                : DateTime.now(),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
      ],
    );
  }
}
