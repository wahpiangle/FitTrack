import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';

class UserProfilePage extends StatefulWidget {
  final FirebaseUser user;

  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
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
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.user.username,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
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
                  SizedBox(height: 8),
                  Text(
                    widget.user.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'loves to workout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Post post = snapshot.data![index];
                            List<String> imageUrls = [post.firstImageUrl, post.secondImageUrl]; // Add more image URLs if needed

                            // Show only the first image
                            String firstImageUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';

                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    firstImageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (imageUrls.length > 1)
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Icon(
                                      Icons.collections,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                              ],
                            );
                          },
                        );



                      } else {
                        return Text('No posts found', style: TextStyle(color: Colors.white));
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
