import 'package:group_project/models/exercise.dart';

import 'bodypart_data.dart';
import 'category_data.dart';

Map<String, Map<String, String>> exerciseMap = {
  'Bench Press': {'Chest': 'Barbell'},
  'Incline Bench Press': {'Chest': 'Barbell'},
  'Decline Bench Press': {'Chest': 'Barbell'},
  'Dumbbell Bench Press': {'Chest': 'Dumbbell'},
};

Map<String, String> imageMap = {
  'Bench Press': 'assets/AbWheel.jpeg',
  'Incline Bench Press': 'assets/aerobics.jpg',
  'Decline Bench Press': 'assets/Aroundtheworld.jpeg',
  'Dumbbell Bench Press': '',
};

List<Exercise> generateExerciseData() {
  List<Exercise> exerciseData = [];
  exerciseMap.forEach((key, value) {
    Exercise exercise = Exercise(name: key, imagePath: imageMap[key]!);
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
