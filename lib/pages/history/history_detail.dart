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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_sharp,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    // TODO: integrate with timer feature
                    'duration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            workoutSession.note == ''
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      workoutSession.note == ''
                          ? 'No notes'
                          : workoutSession.note.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
            Column(
                children: workoutSession.exercisesSetsInfo
                    .map(
                      (exercisesSetInfo) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              exercisesSetInfo.exercise.target!.name,
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
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Text(
                                            (setInfo.key + 1).toString(),
                                            style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          ('${setInfo.value.reps} kg'),
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 16,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            '×',
                                            style: TextStyle(
                                                color: Colors.grey[300],
                                                fontSize: 16),
                                          ),
                                        ),
                                        Text(
                                          setInfo.value.weight.toString(),
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 16,
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
                    .toList())
          ],
        ),
      ),
    );
  }
}
