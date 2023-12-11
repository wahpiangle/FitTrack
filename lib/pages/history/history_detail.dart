import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:intl/intl.dart';

class HistoryDetail extends StatelessWidget {
  final WorkoutSession workoutSession;

  const HistoryDetail({
    super.key,
    required this.workoutSession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton(
            offset: const Offset(0, 50),
            iconColor: Colors.white,
            color: AppColours.primaryBright,
            iconSize: 30,
            surfaceTintColor: Colors.transparent,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  // TODO
                  print("Edit");
                },
                child: const Text(
                  "Edit Workout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  // TODO
                  print("Delete");
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                workoutSession.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            Text(
              DateFormat('EEEE, dd MMMM yyyy, kk:mm a').format(
                workoutSession.date,
              ),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
