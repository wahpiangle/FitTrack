import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/friend/search/user_image_display.dart';
import 'package:group_project/pages/user_profile/user_post_grid.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:group_project/services/firebase/firebase_user_profile_service.dart';

class UserProfilePage extends StatefulWidget {
  final FirebaseUser user;

  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late int postsCount;
  late int friendsCount;
  late Future<void> dataFuture;
  late Future<List<Post>> postsFuture;
  late Future<FriendStatus> friendStatusFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _loadData();
    postsFuture = FirebasePostsService.getPostsByUserId(widget.user.uid);
    friendStatusFuture = FirebaseUserProfileService.checkFriendshipStatus(widget.user.uid);
  }

  Future<void> _loadData() async {
    postsCount = await FirebaseUserProfileService.getPostsCount(widget.user.uid);
    friendsCount = await FirebaseUserProfileService.getFriendsCount(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        title: Text(widget.user.displayName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23)),
        centerTitle: true,
        backgroundColor: AppColours.primary,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
      ),
      body: FutureBuilder<void>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 12),
                  ImageDisplay.buildUserProfileImage(widget.user.photoUrl, radius: 50.0, context: context),
                  const SizedBox(height: 12),
                  Text("@${widget.user.username}", style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  FutureBuilder<FriendStatus>(
                    future: friendStatusFuture,
                    builder: (context, statusSnapshot) {
                      final isFriend = statusSnapshot.data == FriendStatus.friends;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildStatItem("Posts", postsCount),
                            _buildStatItem("Friends", friendsCount, isFriend: isFriend),
                          ],
                        ),
                      );
                    },
                  ),
                  FutureBuilder<FriendStatus>(
                    future: FirebaseUserProfileService.checkFriendshipStatus(widget.user.uid),
                    builder: (context, statusSnapshot) {
                      if (statusSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (statusSnapshot.data == FriendStatus.friends ) {
                        return UserPostsGrid(postsFuture: postsFuture, user: widget.user);

                      }else if (statusSnapshot.data == FriendStatus.requestReceived) {
                        return ElevatedButton(
                          onPressed: ()  async {
                            await FirebaseFriendsService.acceptFriendRequest(widget.user.uid, () {
                              setState(() {

                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColours.secondary,
                            foregroundColor: AppColours.primary,
                          ),
                          child: const Text(
                            'Accept Friend Request',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else if ( statusSnapshot.data == FriendStatus.requestSent) {
                        return ElevatedButton(
                          onPressed: () async{
                            await FirebaseFriendsService.cancelFriendRequest(widget.user.uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Friend request sent to ${widget.user.displayName}')),
                            );
                            setState(() {
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColours.secondary,
                            foregroundColor: AppColours.primary,
                          ),
                          child: const Text(
                            'Cancel friend request',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        // If they are not connected, show add friend button
                        return ElevatedButton(
                          onPressed: () async{
                            await FirebaseFriendsService.addFriend(widget.user.uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Friend request sent to ${widget.user.displayName}')),
                            );
                            setState(() {
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColours.secondary,
                            foregroundColor: AppColours.primary,
                          ),
                          child: const Text(
                            'Add Friend to See Posts',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
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

  Widget _buildStatItem(String label, int count, {bool isFriend = false}) {
    return Row(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
        if (isFriend)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String value) {
              if (value == 'remove_friend') {
                FirebaseFriendsService.removeFriend(widget.user.uid, () {
                  setState(() {
                    // refresh the page
                  });
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'remove_friend',
                child: Text('Remove Friend'),
              ),
            ],
          ),
      ],
    );
  }
}

enum FriendStatus { friends, requestSent, requestReceived, none }
