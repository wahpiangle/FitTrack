import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/exercise_set_info.dart';
import 'package:group_project/pages/workout/choose_exercise.dart';
import 'package:group_project/pages/workout/workout_screen.dart';

class ExerciseTile extends StatefulWidget {
  final List<Exercise> exerciseData;
  final List<String> selectedExercises;
  final void Function(Exercise selectedExercise) selectExercise;
  final void Function(Exercise selectedExercise) removeExercise;

  const ExerciseTile({
    super.key,
    required this.exerciseData,
    required this.selectedExercises,
    required this.selectExercise,
    required this.removeExercise,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  bool checkBox = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.selectedExercises.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  ExerciseSetInfo selectedExercise = ExerciseSetInfo.fromJson(
                    jsonDecode(widget.selectedExercises[index]),
                  );
                  return Column(children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            //TODO: Handle the workout title
                            'snapshot.data!.title',
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
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedExercise.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE1F0CF),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: generateExerciseSetTiles(
                              selectedExercise.exerciseSets,
                            ),
                          )
                        ],
                      ),
                    ),
                  ]);
                }
                if (index == widget.selectedExercises.length) {
                  return Column(children: [
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(15)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF1A1A1A)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                              exercises: widget.exerciseData,
                              selectedExercises: widget.selectedExercises,
                              selectExercise: widget.selectExercise,
                              removeExercise: widget.removeExercise,
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
                    ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(15)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF1A1A1A)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const WorkoutScreen(),
                        ));
                      },
                      child: const Center(
                        child: Text(
                          "CANCEL WORKOUT",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ]);
                } else {
                  ExerciseSetInfo selectedExercise = ExerciseSetInfo.fromJson(
                    jsonDecode(widget.selectedExercises[index]),
                  );
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedExercise.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE1F0CF),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: generateExerciseSetTiles(
                            selectedExercise.exerciseSets,
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> generateExerciseSetTiles(List<ExerciseSet> exerciseSet) {
  return [
    SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          GridView.builder(
            itemCount: exerciseSet.asMap().entries.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 100,
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              int setIndex = index;
              ExerciseSet set =
                  exerciseSet.asMap().entries.elementAt(setIndex).value;

              return GridTile(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0)
                        const Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "Set",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "Weight",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "Reps",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                textAlign: TextAlign.center,
                                "${setIndex + 1}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF333333),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextField(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: TextEditingController(
                                    text: "${set.weight}",
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF333333),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextField(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: TextEditingController(
                                    text: "${set.reps}",
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF333333)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            // onPressed: _addSets,
            onPressed: () {},
            child: const Center(
              child: Text(
                "Add Set",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ];
}
