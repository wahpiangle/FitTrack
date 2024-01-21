import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'package:provider/provider.dart';

class WorkoutHeader extends StatefulWidget {
  const WorkoutHeader({
    super.key,
  });

  @override
  State<WorkoutHeader> createState() => _WorkoutHeaderState();
}

class _WorkoutHeaderState extends State<WorkoutHeader> {
  void onTextFieldChanged(String newText) {
    objectBox.currentWorkoutSessionService
        .updateCurrentWorkoutSessionNote(newText);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: TextFormField(
              initialValue: objectBox.currentWorkoutSessionService
                  .getCurrentWorkoutSessionTitle(),
              onChanged: (String newText) {
                objectBox.currentWorkoutSessionService
                    .updateCurrentWorkoutSessionTitle(newText);
              },
              decoration: InputDecoration(
                hintText: 'Workout title',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Consumer<TimerProvider>(
            builder: (context, timerProvider, child) {
              return Text(
                "Timer: ${TimerProvider.formatTimerDuration(timerProvider.currentDuration)}",
                style: const TextStyle(
                  color: Color(0xFFC1C1C1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: objectBox.currentWorkoutSessionService
                .getCurrentWorkoutSessionNote(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            onChanged: onTextFieldChanged,
            decoration: InputDecoration(
              hintText: 'Add a workout note',
              hintStyle: const TextStyle(
                color: Color(0xFFC1C1C1),
                fontWeight: FontWeight.bold,
              ),
              fillColor: const Color(0xFF333333),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.all(8.0),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
