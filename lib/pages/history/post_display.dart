import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/home/components/front_back_image.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostDisplay extends StatelessWidget {
  final String postId;
  final bool isVisible;

  const PostDisplay({
    Key? key,
    required this.postId,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Transform.translate(
            offset: isVisible ? Offset(0.0, 0.0) : Offset(0.0, 50.0),
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
          opacity: isVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Transform.translate(
            offset: isVisible ? Offset(0.0, 0.0) : Offset(0.0, 50.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Stack(
                children: [
                  FutureBuilder<Post>(
                    future: FirebasePostsService.getPostById(postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final post = snapshot.data!;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 5,
                                right: 0,
                                child: getImageBasedonType(post.firstImageUrl, false),
                              ),
                              Positioned(
                                top: 20,
                                left: 20,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: getImageBasedonType(post.secondImageUrl, true),
                                ),
                              ),
                              Positioned(
                                bottom: 40,
                                right: 5,
                                child: FutureBuilder<List<Reaction>>(
                                  future: FirebasePostsService.getReactionsByPostId(postId),
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
                      future: FirebasePostsService.getPostById(postId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
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
          opacity: isVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            child: TextButton(
              onPressed: () {
                // Handle onPressed action
              },
              child: Text(
                'View Comments',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
