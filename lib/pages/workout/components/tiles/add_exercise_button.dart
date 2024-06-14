import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/workout/components/choose_exercise.dart';

class AddExerciseButton extends StatelessWidget {
  final void Function(Exercise selectedExercise) selectExercise;

  const AddExerciseButton({
    super.key,
    required this.selectExercise,
  });

  @override
  Widget build(BuildContext context) {
    final List<Exercise> exerciseData =
        objectBox.exerciseService.getAllExercises();
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(15)),
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0xFF1A1A1A)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      onPressed: () {
        deselectAllExercises(exerciseData);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseExercise(
              selectExercise: selectExercise,
            ),
          ),
        );
      },
      child: const Center(
        child: Text(
          "ADD EXERCISE",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFE1F0CF),
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
