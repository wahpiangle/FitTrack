import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/history/components/calendar_button.dart';
import 'package:group_project/pages/history/components/workout_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        height: double.infinity,
        color: const Color(0xFF1A1A1A),
        child: StreamBuilder<List<WorkoutSession>>(
          stream: objectBox.workoutSessionService.watchWorkoutSession(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return snapshot.data!.isEmpty
                  ? const Center(
                      child: Text(
                      'No workout sessions yet!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ))
                  : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              CalendarButton(
                                workoutSessions: snapshot.data!,
                              ),
                              WorkoutCard(
                                workoutSession: snapshot.data![index],
                              ),
                            ],
                          );
                        } else {
                          return WorkoutCard(
                            workoutSession: snapshot.data![index],
                          );
                        }
                      },
                    );
            }
          },
        ),
      ),
    );
  }
}
