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
    Key? key,
    required this.postId,
    required this.isVisible,
  }) : super(key: key);

  @override
  _PostDisplayState createState() => _PostDisplayState();
}



class _PostDisplayState extends State<PostDisplay> {
  bool _showComments = false;
  bool _isScrollDisabled = false;

  void disableScroll() {
    setState(() {
      _isScrollDisabled = true;
    });
  }

  void enableScroll() {
    setState(() {
      _isScrollDisabled;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          opacity: widget.isVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Transform.translate(
            offset: widget.isVisible ? Offset(0.0, 0.0) : Offset(0.0, 50.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
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
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Transform.translate(
            offset: widget.isVisible ? Offset(0.0, 0.0) : Offset(0.0, 50.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Stack(
                children: [
                  FutureBuilder<Post>(
                    future: FirebasePostsService.getPostById(widget.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final post = snapshot.data!;
                        return post.firstImageUrl.isNotEmpty || post.secondImageUrl.isNotEmpty
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
                                    imagePath2: post.secondImageUrl, // Pass an empty string or null since it's not used in this context
                                    disableScroll: null, // You can pass null for these parameters as they're not used in this context
                                    enableScroll: null, // You can pass null for these parameters as they're not used in this context
                                  ),
                                ),
                              Positioned(
                                bottom: 40,
                                right: 5,
                                child: FutureBuilder<List<Reaction>>(
                                  future: FirebasePostsService.getReactionsByPostId(widget.postId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      final reactions = snapshot.data!;
                                      final reactionImageUrl = reactions.isNotEmpty ? reactions[0].imageUrl : '';
                                      return reactionImageUrl.isNotEmpty
                                          ? Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.black),
                                        ),
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: reactionImageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        ),
                                      )
                                          : SizedBox();
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                            : Center(
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
                        return Center(child: Text('No data available'));
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
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          final post = snapshot.data!;
                          if (post.caption.isNotEmpty) {
                            return Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15), // Adjust the value as needed
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Text(
                                  post.caption,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return SizedBox();
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
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            child: FutureBuilder<Post>(
              future: FirebasePostsService.getPostById(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final post = snapshot.data!;
                  return post.firstImageUrl.isNotEmpty || post.secondImageUrl.isNotEmpty
                      ? TextButton( // Wrap TextButton in this condition
                    onPressed: () {
                      setState(() {
                        _showComments = !_showComments;
                      });
                      print('postId: ${widget.postId}');
                    },
                    child: Text(
                      _showComments ? 'Hide Comments' : 'View Comments',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                      : SizedBox(); // Return an empty SizedBox if there are no posts
                } else {
                  return SizedBox(); // Return an empty SizedBox if no data available
                }
              },
            ),
          ),
        ),

        // Show comments if _showComments is true
        // Inside PostDisplay widget
        // Inside the PostDisplay widget where you use CommentTile
        if (_showComments)
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseCommentService.getCommentStreamById(widget.postId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final comments = snapshot.data?.docs;
                if (comments == null || comments.isEmpty) {
                  return Center(child: Text('No comments available'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                          date: date != null ? DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000) : DateTime.now(), // Handle null DateTime
                        ),
                      );
                    },
                  );
                }
              }
            },
          ),

      ],
    );
  }
}
