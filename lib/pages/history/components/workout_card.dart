import 'package:flutter/material.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/history/components/workout_menu_anchor.dart';
import 'package:group_project/pages/history/history_detail.dart';
import 'package:intl/intl.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutSession workoutSession;
  const WorkoutCard({
    super.key,
    required this.workoutSession,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => HistoryDetail(
              workoutSession: workoutSession,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xFFE1F0CF),
            width: 1,
          ),
        ),
        child: ListTile(
          tileColor: const Color(0xFF1A1A1A),
          trailing: WorkoutMenuAnchor(workoutSessionId: workoutSession.id),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workoutSession.title.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  // show pm or am
                  DateFormat('dd MMMM').format(
                    workoutSession.date,
                  ),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          subtitle: ListView.builder(
            shrinkWrap: true,
            itemCount: workoutSession.exercisesSetsInfo.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Text(
                    "${workoutSession.exercisesSetsInfo[index].exerciseSets.length} × ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    workoutSession
                        .exercisesSetsInfo[index].exercise.target!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
