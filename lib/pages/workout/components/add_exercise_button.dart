import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/workout/components/choose_exercise.dart';

class AddExerciseButton extends StatelessWidget {
  final List<Exercise> exerciseData;
  final List<dynamic> selectedExercises; //TODO
  final void Function(Exercise selectedExercise) selectExercise;

  const AddExerciseButton({
    super.key,
    required this.exerciseData,
    required this.selectedExercises,
    required this.selectExercise,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(15)),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xFF1A1A1A)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseExercise(
              exercises: exerciseData,
              selectedExercises: selectedExercises,
              selectExercise: selectExercise,
            ),
          ),
        );
      },
      child: const Center(
        child: Text(
          "ADD EXERCISE",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFE1F0CF),
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
