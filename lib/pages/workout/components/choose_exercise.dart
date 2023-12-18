import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/components/crop_image.dart';

class ChooseExercise extends StatefulWidget {
  final List<Exercise> exercises;
  final List<dynamic> selectedExercises; //TODO
  final void Function(Exercise selectedExercise) selectExercise;

  const ChooseExercise({
    super.key,
    required this.exercises,
    required this.selectedExercises,
    required this.selectExercise,
  });

  @override
  _ChooseExerciseState createState() => _ChooseExerciseState();
}

class _ChooseExerciseState extends State<ChooseExercise> {
  List<Exercise> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    filteredExercises = widget.exercises;
  }

  void filterExercises(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredExercises = widget.exercises;
      } else {
        filteredExercises = widget.exercises
            .where((exercise) =>
                exercise.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }


  // //MODIFIED
  // void _selectExercise(Exercise selectedExercise) {
  //   // Show floating action button to add exercise
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Add Exercise ${selectedExercise.name}?'),
  //       behavior: SnackBarBehavior.floating,
  //       duration: const Duration(days: 365), // Make the SnackBar stay
  //       action: SnackBarAction(
  //         label: 'Add',
  //         onPressed: () {
  //           // Add exercise to the workout
  //           widget.selectExercise(selectedExercise);
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ),
  //   );
  // }

  void submitSelectedExercise(Exercise selectedExercise) {
    if (selectedExercise.isSelected) {
      widget.selectExercise(selectedExercise);
    }
  }



  void _selectExercise(Exercise selectedExercise) {
    setState(() {
      selectedExercise.isSelected = !selectedExercise.isSelected;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Choose an Exercise"),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Container(
        color: const Color(0xFF1A1A1A),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: filterExercises,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search for an exercise...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = filteredExercises[index];
                  return Material(
                    color: const Color(0xFF1A1A1A),
                    child: InkWell(
                      onTap: () {
                        _selectExercise(exercise);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          tileColor: exercise.isSelected ? Colors.grey[800] : null,
                          horizontalTitleGap: -10,
                          leading: SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(300.0),
                              child: exercise.imagePath == ''
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE1F0CF),
                                        borderRadius:
                                            BorderRadius.circular(300.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          exercise.name[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ClipPath(
                                      clipper: MyClipperPath(),
                                      child: Container(
                                        height: 60,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image: Image.asset(exercise.imagePath)
                                              .image,
                                          fit: BoxFit
                                              .contain, //or whatever BoxFit you want
                                        )),
                                      ),
                                    ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              exercise.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            exercise.bodyPart.target!.name,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (final exercise in widget.exercises) {
            submitSelectedExercise(exercise);
          }
          Navigator.pop(context);
        },
        backgroundColor: const Color(0xFFE1F0CF),
        child: const Icon(Icons.add),
      ),

    );
  }
}
