import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';
import 'package:group_project/pages/home/components/display_post_screen/comment/comment_tile.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:group_project/services/firebase/firebase_comment_service.dart'; // Import the FirebaseCommentService
import 'package:cached_network_image/cached_network_image.dart';

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
  bool _showComments = false;


  void disableScroll() {
    setState(() {
    });
  }

  void enableScroll() {
    setState(() {
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
            child: Container(
              height: MediaQuery.of(context).size.height * 0.62,
              width: MediaQuery.of(context).size.width * 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Stack(
                children: [
                  FutureBuilder<Post>(
                    future: FirebasePostsService.getPostById(widget.postId),
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
                                borderRadius: BorderRadius.circular(20),
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
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 40,
                                      right: 5,
                                      child: FutureBuilder<List<Reaction>>(
                                        future: FirebasePostsService
                                            .getReactionsByPostId(
                                                widget.postId),
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
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FutureBuilder<Post>(
                      future: FirebasePostsService.getPostById(widget.postId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          final post = snapshot.data!;
                          if (post.caption.isNotEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    15), // Adjust the value as needed
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Text(
                                  post.caption,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: widget.isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: FutureBuilder<Post>(
            future: FirebasePostsService.getPostById(widget.postId),
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
                        // Wrap TextButton in this condition
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
                    : const SizedBox(); // Return an empty SizedBox if there are no posts
              } else {
                return const SizedBox(); // Return an empty SizedBox if no data available
              }
            },
          ),
        ),

        // Show comments if _showComments is true
        // Inside PostDisplay widget
        // Inside the PostDisplay widget where you use CommentTile
        if (_showComments)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3, // Adjust the height as needed
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseCommentService.getCommentStreamById(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final comments = snapshot.data?.docs;
                  if (comments == null || comments.isEmpty) {
                    // If no comments are available, show a message
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
                        final postedBy = commentData['postedBy'] ?? ''; // Get the user ID
                        final date = commentData['date']; // Get the comment date

                        return CommentTile(
                          comment: Comment(
                            id: '', // Provide an appropriate id value
                            postId: widget.postId, // Pass the postId of the current post
                            comment: comment,
                            postedBy: postedBy,
                            date: date != null
                                ? DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000)
                                : DateTime.now(), // Handle null DateTime
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
