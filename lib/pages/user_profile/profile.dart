import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/friend/search/user_image_display.dart';
import 'package:group_project/pages/user_profile/user_post_grid.dart';
import 'package:group_project/services/firebase/firebase_friends_service.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:group_project/services/firebase/firebase_user_profile_service.dart';
import 'package:group_project/services/firebase/firebase_workouts_service.dart';

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
  late Future<FriendStatus> friendStatusFuture;
  Pair<ExerciseSet, String>? overallBestSetPair;

  @override
  void initState() {
    super.initState();
    dataFuture = _loadData();
    postsFuture = FirebasePostsService.getPostsByUserId(widget.user.uid);
    friendStatusFuture =
        FirebaseUserProfileService.checkFriendshipStatus(widget.user.uid);
    loadOverallBestSet();
  }


  Future<void> loadOverallBestSet() async {
    try {
      List<FirebaseWorkoutSession> sessions = await FirebaseWorkoutsService.getWorkoutSessionsByUserId(widget.user.uid);

      final manager = WorkoutSessionsManager(sessions: sessions);
      final bestSetPair = manager.getOverallBestSet();
      setState(() {
        overallBestSetPair = bestSetPair;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _loadData() async {
    postsCount =
    await FirebaseUserProfileService.getPostsCount(widget.user.uid);
    friendsCount =
    await FirebaseUserProfileService.getFriendsCount(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        title: Text(widget.user.displayName, style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23)),
        centerTitle: true,
        backgroundColor: AppColours.primary,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: FutureBuilder<void>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: <Widget>[
                          ImageDisplay.buildUserProfileImage(widget.user.photoUrl, radius: 50.0, context: context),
                          const SizedBox(height: 12),
                          Text("@${widget.user.username}", style: const TextStyle(color: AppColours.secondaryLight, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(width: 20), // Spacer
                      Column( // New column for the barbell icon and text
                        children: <Widget>[
                          Icon(Icons.fitness_center, size: 24.0, color: Colors.white), // Barbell icon
                          Text('Overall Best Exercise Set', style: TextStyle(color: Colors.white, fontSize: 16)), // Exercise text
                          if (overallBestSetPair != null)
                            Column(
                              children: [
                                Text('Best Set: ${overallBestSetPair!.first.weight} lbs x ${overallBestSetPair!.first.reps}', style: TextStyle(color: Colors.white)),
                                Text('Exercise: ${overallBestSetPair!.second}', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<FriendStatus>(
                    future: friendStatusFuture,
                    builder: (context, statusSnapshot) {
                      final isFriend = statusSnapshot.data ==
                          FriendStatus.friends;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildStatItem("Posts", postsCount),
                            _buildStatItem(
                                "Friends", friendsCount, isFriend: isFriend),
                          ],
                        ),
                      );
                    },
                  ),
                  FutureBuilder<FriendStatus>(
                    future: FirebaseUserProfileService.checkFriendshipStatus(
                        widget.user.uid),
                    builder: (context, statusSnapshot) {
                      if (statusSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (statusSnapshot.data == FriendStatus.friends) {
                        return UserPostsGrid(
                            postsFuture: postsFuture, user: widget.user);
                      } else
                      if (statusSnapshot.data == FriendStatus.requestReceived) {
                        return ElevatedButton(
                          onPressed: () async {
                            await FirebaseFriendsService.acceptFriendRequest(
                                widget.user.uid, () {
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
                      } else
                      if (statusSnapshot.data == FriendStatus.requestSent) {
                        return ElevatedButton(
                          onPressed: () async {
                            await FirebaseFriendsService.cancelFriendRequest(
                                widget.user.uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  'Friend request sent to ${widget.user
                                      .displayName}')),
                            );
                            setState(() {});
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
                          onPressed: () async {
                            await FirebaseFriendsService.addFriend(
                                widget.user.uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  'Friend request sent to ${widget.user
                                      .displayName}')),
                            );
                            setState(() {});
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: screenWidth * 0.30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(label, style: const TextStyle(color: AppColours.secondaryLight, fontSize: 16)),
            ],
          ),
        ),
        if (isFriend)
          Container(
            width: screenWidth * 0.25,
            alignment: Alignment.topCenter,
            child: PopupMenuButton<String>(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              color: AppColours.secondaryLight,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Friends', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.expand_more_outlined, color: Colors.white),
                ],
              ),
              onSelected: (String value) {
                if (value == 'remove_friend') {
                  FirebaseFriendsService.removeFriend(widget.user.uid, () {
                    setState(() {});
                  });
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'remove_friend',
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    leading: Icon(Icons.person_off, color: AppColours.primary), // Icon
                    title: Text('Remove Friend', style: TextStyle(fontWeight: FontWeight.bold, color: AppColours.primary)), // Text style
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

}


enum FriendStatus { friends, requestSent, requestReceived, none }
