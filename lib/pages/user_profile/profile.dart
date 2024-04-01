import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/friend/search/user_image_display.dart';
import 'package:group_project/pages/user_profile/friend_status_handler.dart';
import 'package:group_project/pages/user_profile/overall_workout_best_set.dart';
import 'package:group_project/pages/user_profile/statistic_items.dart';
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

      final manager = OverallWorkoutBestSet(sessions: sessions);
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
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: <Widget>[
                            ImageDisplay.buildUserProfileImage(widget.user.photoUrl, radius: 50.0, context: context),
                            const SizedBox(height: 12),
                            Text("@${widget.user.username}", style: const TextStyle(color: AppColours.secondaryLight, fontSize: 18)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text(
                                      '🏆',
                                      style: TextStyle(
                                        fontSize: 26,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'Best',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    overallBestSetPair != null ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(overallBestSetPair!.second, style: const TextStyle(color: AppColours.secondaryLight, fontSize: 14)),
                                        Text('${overallBestSetPair!.first.weight} kg x ${overallBestSetPair!.first.reps}', style: const TextStyle(color: AppColours.secondaryLight, fontSize: 14)),
                                      ],
                                    ) : const Text('No best set', style: TextStyle(color: AppColours.secondaryLight, fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
                        StatItem(label: "Posts", count: postsCount, userId: widget.user.uid),
                        StatItem(label: "Friends", count: friendsCount, isFriend: isFriend, userId: widget.user.uid),
                        ],
                        ),
                      );
                    },
                  ),
                  FriendStatusHandler(
                    friendStatusFuture: friendStatusFuture,
                    postsFuture: postsFuture,
                    user: widget.user,
                    onStatusChanged: () => setState(() {
                       friendStatusFuture = FirebaseUserProfileService.checkFriendshipStatus(widget.user.uid);
                    }),
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


}


enum FriendStatus { friends, requestSent, requestReceived, none }
