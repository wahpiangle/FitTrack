import 'package:flutter/material.dart';

class WorkoutHeader extends StatefulWidget {
  const WorkoutHeader({
    super.key,
  });

  @override
  State<WorkoutHeader> createState() => _WorkoutHeaderState();
}

class _WorkoutHeaderState extends State<WorkoutHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(children: [
        Container(
          alignment: Alignment.topLeft,
          child: const Text(
            //TODO: Handle the workout title
            'snapshot.data!.title',
            style: TextStyle(
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
          onChanged: (value) {
            //TODO: Handle the workout note
          },
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
      ]),
    );
  }
}
