import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_image_screen.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';

class UserProfilePage extends StatefulWidget {
  final FirebaseUser user;

  const UserProfilePage({super.key, required this.user});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late int postsCount;
  late int friendsCount;
  late Future<void> dataFuture;
  late Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _loadData();
    postsFuture = FirebasePostsService.getPostsByUserId(widget.user.uid);
  }

  Future<void> _loadData() async {
    postsCount = await _getPostsCount(widget.user.uid);
    friendsCount = await _getFriendsCount(widget.user.uid);
  }

  Future<int> _getPostsCount(String userId) async {
    final posts = await FirebasePostsService.getPostsByUserId(userId);
    return posts.length;
  }

  Future<int> _getFriendsCount(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final friendsUids = userDoc.data()?['friends'] as List<dynamic>? ?? [];
    return friendsUids.length;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        title: Text(
          widget.user.displayName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),
        ),
        centerTitle: true,
        backgroundColor: AppColours.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Implement more actions
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.photoUrl),
                    radius: 50,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "@${widget.user.username}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildStatItem("Posts", postsCount),
                        _buildStatItem("Friends", friendsCount),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Post>>(
                    future: postsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Post post = snapshot.data![index];
                            List<String> imageUrls = [post.firstImageUrl, post.secondImageUrl];

                            String firstImageUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DisplayPostImageScreen(
                                      post: post,
                                      posterInfo: widget.user,
                                      index: 0,
                                      firebaseUserPosts: [FirebaseUserPost(post, widget.user, [], [])],
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      firstImageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );


                      } else {
                        return const Text('No posts found', style: TextStyle(color: Colors.white));
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
