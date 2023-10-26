import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final String category;
  final String bodyPart;
  final String imagePath;

  Exercise(this.name, this.category, this.bodyPart, this.imagePath);
}

final List<Exercise> exercises = [
  Exercise('Aerobics', 'Exercise Category A', 'Body Part A', 'assets/aerobics.jpg'),
  Exercise('AbWheel', 'Exercise Category B', 'Body Part B', 'assets/AbWheel.jpeg'),
  Exercise('Around the world', 'Exercise Category C', 'Body Part B', 'assets/Aroundtheworld.jpeg'),
  Exercise('Bicep Curl (Dumb Bell)', 'Exercise Category B', 'Body Part B', 'assets/Bicep Curl (Dumbbell).jpg'),
  Exercise('Cable Crossover', 'Exercise Category A', 'Body Part B', 'assets/Cable Crossover.jpg'),
  // Add more exercises here
];

class ExerciseListScreen extends StatefulWidget {
  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}


class _ExerciseListScreenState extends State<ExerciseListScreen> {
  String searchText = '';
  String selectedCategory = 'All'; // Default to 'All'
  Map<String, List<Exercise>> exerciseGroups = {};

  final GlobalKey _filterButtonKey = GlobalKey();
  Rect? filterButtonRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox filterButton = _filterButtonKey.currentContext?.findRenderObject() as RenderBox;
      final Offset buttonPosition = filterButton.localToGlobal(Offset.zero);
      filterButtonRect = Rect.fromPoints(
        buttonPosition,
        buttonPosition.translate(filterButton.size.width, filterButton.size.height),
      );
      groupExercises();
      // Populate the list with 'All' exercises by default
      filterExercises('', 'All');
    });
  }

  void groupExercises() {
    final groupedExercises = <String, List<Exercise>>{};
    for (final exercise in exercises) {
      final firstLetter = exercise.name[0].toUpperCase();
      if (!groupedExercises.containsKey(firstLetter)) {
        groupedExercises[firstLetter] = [];
      }
      groupedExercises[firstLetter]!.add(exercise);
    }
    exerciseGroups = groupedExercises;
  }

  void filterExercises(String query, String category) {
    setState(() {
      searchText = query;
      selectedCategory = category;
    });
  }

  void showFilterMenu(BuildContext context) {
    if (filterButtonRect != null) {
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          filterButtonRect!.left + 70.0,
          filterButtonRect!.bottom + 70.0,
          filterButtonRect!.right,
          filterButtonRect!.bottom + 10.0,
        ),
        items: <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'All',
            child: Text('All'),
          ),
          PopupMenuItem<String>(
            value: 'Core',
            child: Text('Core'),
          ),
          PopupMenuItem<String>(
            value: 'Arms',
            child: Text('Arms'),
          ),
          PopupMenuItem<String>(
            value: 'Back',
            child: Text('Back'),
          ),
          PopupMenuItem<String>(
            value: 'Chest',
            child: Text('Chest'),
          ),
          PopupMenuItem<String>(
            value: 'Legs',
            child: Text('Legs'),
          ),
          PopupMenuItem<String>(
            value: 'Shoulders',
            child: Text('Shoulders'),
          ),
          PopupMenuItem<String>(
            value: 'Other',
            child: Text('Other'),
          ),
          PopupMenuItem<String>(
            value: 'Olympic',
            child: Text('Olympic'),
          ),
          PopupMenuItem<String>(
            value: 'Full Body',
            child: Text('Full Body'),
          ),
          PopupMenuItem<String>(
            value: 'Cardio',
            child: Text('Cardio'),
          ),
        ],
      ).then((value) {
        if (value != null) {
          filterExercises(searchText, value);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
        backgroundColor: Color(0xFF1A1A1A),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          key: _filterButtonKey,
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Color(0xFF1A1A1A),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Color(0xFF333333)),
                        color: Color(0xFF333333),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Color(0xFF333333)),
                        ),
                        child: TextField(
                          onChanged: (query) {
                            filterExercises(query, selectedCategory);
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Color(0xFF333333)),
                        color: Color(0xFF333333),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.filter_list, color: Colors.white, size: 24.0),
                        onPressed: () {
                          showFilterMenu(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            Container(
              height: 48.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align to the left
                children: [
                  // Show a single circular rectangle for the selected category
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: 80.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.black),
                        color: Color(0xFFE1F0CF), // Green color
                      ),
                      child: Center(
                        child: Text(
                          selectedCategory,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: exerciseGroups.length,
                itemBuilder: (context, index) {
                  final alphabet = exerciseGroups.keys.elementAt(index);
                  final groupExercises = exerciseGroups[alphabet] ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          alphabet,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        children: groupExercises
                            .where((exercise) =>
                        exercise.name.toLowerCase().contains(searchText.toLowerCase()) &&
                            (selectedCategory == 'All' || exercise.category == selectedCategory))
                            .map((exercise) => ExerciseListItem(exercise: exercise))
                            .toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;

  ExerciseListItem({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF333333)),
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xFF333333),
      ),
      child: ListTile(
        leading: Image.asset(exercise.imagePath, width: 50, height: 50),
        title: Text(
          exercise.name,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ExerciseListScreen()));
}
