import 'package:flutter/material.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/history/menu_anchor/workout_menu_anchor.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xFFE1F0CF),
            width: 1,
          ),
        ),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
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
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: ListTile(
              tileColor: Colors.transparent,
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
                      DateFormat('dd MMMM yyyy').format(
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
                        workoutSession.exercisesSetsInfo[index].exercise.target
                                ?.name ??
                            '',
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
        ),
      ),
    );
  }
}
