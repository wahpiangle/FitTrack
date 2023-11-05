class ExerciseSet {
  final int weight;
  final int reps;
  bool isCompleted = false;

  ExerciseSet({required this.weight, required this.reps});

  ExerciseSet.fromJson(Map<String, dynamic> json)
      : weight = json['weight'],
        reps = json['reps'],
        isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'reps': reps,
        'isCompleted': isCompleted,
      };
}
