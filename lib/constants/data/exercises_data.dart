import 'package:group_project/models/exercise.dart';

import 'bodypart_data.dart';
import 'category_data.dart';

Map<String, Map<String, String>> exerciseMap = {
  'Bench Press (Barbell)': {'Chest': 'Barbell'},
  'Incline Bench Press (Barbell)': {'Chest': 'Barbell'},
  'Bench Press (Dumbbell)': {'Chest': 'Dumbbell'},
  'Deadlift (Barbell)': {'Back': 'Barbell'},
};

Map<String, String> imageMap = {
  'Bench Press (Barbell)': 'assets/exercises/barbell-bench.png',
  'Incline Bench Press (Barbell)': 'assets/exercises/incline-barbell-bench.png',
  'Bench Press (Dumbbell)': 'assets/exercises/dumbbell-bench.png',
  'Deadlift (Barbell)': 'assets/exercises/barbell-deadlift.png',
};

Map<String, String> halfImageMap = {
  'Bench Press (Barbell)': 'assets/exercises/half/barbell-bench-half.png',
  'Incline Bench Press (Barbell)':
      'assets/exercises/half/incline-barbell-bench-half.png',
  'Bench Press (Dumbbell)': 'assets/exercises/half/dumbbell-bench-half.png',
  'Deadlift (Barbell)': 'assets/exercises/half/barbell-deadlift-half.png',
};

List<Exercise> generateExerciseData() {
  List<Exercise> exerciseData = [];
  exerciseMap.forEach((key, value) {
    Exercise exercise = Exercise(
        name: key,
        imagePath: imageMap[key]!,
        halfImagePath: halfImageMap[key]!, );
    exercise.bodyPart.target = bodyPartData.firstWhere((element) {
      return element.name == value.keys.first;
    });
    exercise.category.target = categoryData.firstWhere((element) {
      return element.name == value.values.first;
    });
    exerciseData.add(exercise);
  });
  return exerciseData;
}
