import 'package:flutter/material.dart';
import '../../../models/current_workout_session.dart';
import '../../../services/objectbox_service.dart';

class WorkoutHeader extends StatefulWidget {
  final CurrentWorkoutSession currentWorkoutSession;
  final ObjectBox objectBoxService;

  const WorkoutHeader({
    Key? key,
    required this.currentWorkoutSession,
    required this.objectBoxService,
  }) : super(key: key);

  @override
  State<WorkoutHeader> createState() => _WorkoutHeaderState(objectBoxService);
}


class _WorkoutHeaderState extends State<WorkoutHeader> {
  final ObjectBox objectBoxService;

  _WorkoutHeaderState(this.objectBoxService); // Update the constructor

  void onTextFieldChanged(String newText) {
    CurrentWorkoutSession currentWorkoutSession = objectBoxService.getCurrentWorkoutSession();
    currentWorkoutSession.note = newText;
    objectBoxService.updateCurrentWorkoutSessionNote(newText);
    print('New note value: $newText');
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              widget.currentWorkoutSession.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
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
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}