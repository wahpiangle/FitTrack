import 'package:flutter/material.dart';
import 'package:group_project/main.dart';

class WorkoutHeader extends StatefulWidget {
  const WorkoutHeader({
    super.key,
  });

  @override
  State<WorkoutHeader> createState() => _WorkoutHeaderState();
}

class _WorkoutHeaderState extends State<WorkoutHeader> {
  void onTextFieldChanged(String newText) {
    objectBox.updateCurrentWorkoutSessionNote(newText);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: const Text(
              'Workout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: objectBox.getCurrentWorkoutSessionNote(),
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
