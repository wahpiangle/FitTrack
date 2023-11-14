import 'package:flutter/material.dart';
import 'package:group_project/models/exercise_set.dart';
//import 'package:group_project/models/exercise_sets_info.dart';



class SetTiles extends StatefulWidget {
  final int exercisesSetsInfoId;
  String exerciseName;
  final List<ExerciseSet> exerciseSet;
  final void Function(int exerciseSetId) removeSet;
  final void Function(int exerciseNameId) removeExerciseName;

 SetTiles({
    Key? key,
    required this.exercisesSetsInfoId,
    required this.exerciseName,
    required this.exerciseSet,
    required this.removeSet,
   required this.removeExerciseName,
 }) : super(key: key);

  @override
  State<SetTiles> createState() => _SetTilesState();
}

class _SetTilesState extends State<SetTiles> {
  List<ExerciseSet> sets = [];

  @override
  void initState() {
    super.initState();
    sets.addAll(widget.exerciseSet);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScrollConfiguration(
          behavior: NoGlowBehaviour(),
          child: sets.isEmpty
              ? Center(
            child: Text(
              'No sets available. Add a new set to start.',
              style: TextStyle(fontSize: 18),
            ),
          )
              : ListView.builder(
            itemCount: sets.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              int setIndex = index;
              ExerciseSet set = sets[setIndex];
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    sets.removeAt(setIndex);
                    widget.removeSet(set.id);

                    if (sets.isEmpty) {
                      // Show a dialog to confirm exercise deletion
                      _showDeleteExerciseDialog();
                    }
                  });
                },
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text(
                          textAlign: TextAlign.center,
                          "${setIndex + 1}",
                          style: const TextStyle(
                            fontSize: 18,
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
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            controller: TextEditingController(
                              text: "${set.weight}",
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
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
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            controller: TextEditingController(
                              text: "${set.reps}",
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 40,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              // Call the delete method when the button is pressed
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xFF333333)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                // Add a new set when the button is pressed
                ExerciseSet newSet = ExerciseSet(id: sets.length + 1, weight: 0, reps: 0);
                sets.add(newSet);
                //ObjectBoxService.saveExercisesSetsInfo(exercisesSetsInfo);

              });
            },
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
        ),
      ],
    );
  }

  void removeExerciseName(int exerciseNameId) {
    // Assuming that exerciseNameId is the identifier for an exercise name
    widget.removeExerciseName(exerciseNameId);

    // Clear the sets list
    setState(() {
      sets.clear();
    });
  }

  void _deleteExercise() {
    widget.removeSet(widget.exercisesSetsInfoId);
    removeExerciseName(widget.exercisesSetsInfoId);
  }

  void _showDeleteExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Exercise?'),
        content: Text('Do you want to delete the chosen exercise?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteExercise();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class ObjectBoxService {
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return child;
  }
}
