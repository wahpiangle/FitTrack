import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/history/menu_anchor/workout_menu_anchor.dart';
import 'package:group_project/pages/home/components/front_back_image.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:intl/intl.dart';

class HistoryDetail extends StatefulWidget {
  final WorkoutSession workoutSession;

  const HistoryDetail({
    Key? key,
    required this.workoutSession,
  }) : super(key: key);

  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Add a delay to start the animation after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;
    final hoursString = '$hours'.padLeft(2, '0');
    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$hoursString:$minutesString:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          WorkoutMenuAnchor(
              workoutSessionId: widget.workoutSession.id, isDetailPage: true)
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  widget.workoutSession.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Text(
                DateFormat('EEEE, dd MMMM yyyy, kk:mm a').format(
                  widget.workoutSession.date,
                ),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_sharp,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formatDuration(widget.workoutSession.duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              widget.workoutSession.note == ''
                  ? const SizedBox()
                  : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  widget.workoutSession.note == ''
                      ? 'No notes'
                      : widget.workoutSession.note.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              Column(
                children: widget.workoutSession.exercisesSetsInfo
                    .map(
                      (exercisesSetInfo) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0),
                        child: Text(
                          exercisesSetInfo.exercise.target?.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Column(
                        children: exercisesSetInfo.exerciseSets
                            .asMap()
                            .entries
                            .map(
                              (setInfo) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20),
                                  child: Text(
                                    (setInfo.key + 1).toString(),
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            ('${setInfo.value.weight} kg × ${setInfo.value.reps}'),
                                            style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      setInfo.value.isPersonalRecord
                                          ? Container(
                                        padding:
                                        const EdgeInsets.all(
                                            5),
                                        decoration:
                                        const BoxDecoration(
                                          color: AppColours
                                              .secondary,
                                          borderRadius:
                                          BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                          '🏆 PR',
                                          style: TextStyle(
                                            color:
                                            Colors.green[900],
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
              SizedBox(height: 50),
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Transform.translate(
                  offset: _isVisible ? Offset(0.0, 0.0) : Offset(0.0, 50.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Your Memories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Dancing Script',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Transform.translate(
                  offset: _isVisible ? Offset(0.0, 0.0) : Offset(0.0, 50.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: FutureBuilder<Post>(
                      future: FirebasePostsService.getPostById(widget.workoutSession.postId),
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
                                  bottom: 10,
                                  right: 10,
                                  child: FutureBuilder<List<Reaction>>(
                                    future: FirebasePostsService.getReactionsByPostId(widget.workoutSession.postId),
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
                  ),

                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
