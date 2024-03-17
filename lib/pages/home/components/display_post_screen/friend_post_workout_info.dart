import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_workout_session.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/home/components/display_post_screen/own_post_workout_info.dart';
import 'package:group_project/services/firebase/firebase_workouts_service.dart';
import 'package:intl/intl.dart';

class FriendPostWorkoutInfo extends StatefulWidget {
  final Post post;
  final FirebaseUser posterInfo;
  const FriendPostWorkoutInfo({
    super.key,
    required this.post,
    required this.posterInfo,
  });

  @override
  State<FriendPostWorkoutInfo> createState() => _FriendPostWorkoutInfoState();
}

class _FriendPostWorkoutInfoState extends State<FriendPostWorkoutInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseWorkoutsService.getWorkoutSessionByUser(
          widget.post.workoutSessionId, widget.post.postedBy),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
            child: Text(
              'An error occurred',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          final workoutSession = snapshot.data as FirebaseWorkoutSession;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: CachedNetworkImage(
                              imageUrl: widget.posterInfo.photoUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/icons/defaultimage.jpg'),
                            ),
                          );
                        });
                  },
                  child: widget.posterInfo.photoUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                            widget.posterInfo.photoUrl,
                          ),
                        )
                      : const CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.person,
                            size: 30,
                          ),
                        ),
                ),
                title: Text(
                  widget.posterInfo.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  DateFormat('EEEE, hh:mm:ss a').format(widget.post.date),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                workoutSession.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Duration',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formatDuration(workoutSession.duration),
                            style: const TextStyle(
                              color: AppColours.secondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          );
        }
        return Container();
      },
    );
  }
}
