import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/history/calendar/history_calendar.dart';

class CalendarButton extends StatelessWidget {
  final List<WorkoutSession> workoutSessions;
  final void Function(WorkoutSession) scrollToItem;

  const CalendarButton({
    super.key,
    required this.workoutSessions,
    required this.scrollToItem,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(
          Icons.calendar_today_sharp,
          size: 30,
          color: AppColours.secondary,
        ),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryCalendar(
                workoutSessions: workoutSessions,
                scrollToItem: scrollToItem,
              ),
            ),
          )
        },
      ),
    );
  }
}
