import 'package:flutter/material.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/home/components/display_post_screen/display_post_image_screen.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';

class UserPostsGrid extends StatelessWidget {
  final Future<List<Post>> postsFuture;
  final FirebaseUser user;

  const UserPostsGrid({
    Key? key,
    required this.postsFuture,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
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
              String secondImageUrl = imageUrls.isNotEmpty ? imageUrls[1] : '';
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayPostImageScreen(
                        posterInfo: user,
                        index: 0,
                        firebaseUserPosts: [FirebaseUserPost(post, user, [], [])],
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
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 35,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            secondImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              );
            },
          );
        }  else {
          return const Text('No posts found', style: TextStyle(color: Colors.white));
        }
      },
    );
  }
}
