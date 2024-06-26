import 'package:flutter/material.dart';
import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/bodypart_data.dart';
import 'components/exercise_filter_widgets.dart';

class ExerciseFilterPage extends StatefulWidget {
  final Function(dynamic bodyPart) setBodyPart;
  final String selectedBodyPart;
  final List<String> selectedCategory;
  final Function(dynamic category) addCategory;
  final Function(dynamic category) removeCategory;

  const ExerciseFilterPage({
    super.key,
    required this.setBodyPart,
    required this.selectedBodyPart,
    required this.selectedCategory,
    required this.addCategory,
    required this.removeCategory,
  });

  @override
  ExerciseFilterPageState createState() => ExerciseFilterPageState();
}

class ExerciseFilterPageState extends State<ExerciseFilterPage> {
  String selectedBodyPart = '';
  List<String> selectedCategories = [];

  void changeExerciseState(String bodyPart) {
    setState(() {
      if (selectedBodyPart == bodyPart) {
        selectedBodyPart = '';
        widget.setBodyPart('');
      } else {
        selectedBodyPart = bodyPart;
        widget.setBodyPart(bodyPart);
      }
    });
  }

  void changeCategoryState(String categoryName) {
    setState(() {
      if (selectedCategories.contains(categoryName)) {
        widget.removeCategory(categoryName);
      } else {
        widget.addCategory(categoryName);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectedCategories = widget.selectedCategory;
    selectedBodyPart = widget.selectedBodyPart;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'Filter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Separated section for Body Parts
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Body Parts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ExerciseFilterWidgets(
                data: bodyPartData,
                isBodyPart: true,
                isCategory: false,
                state: this),
            const SizedBox(height: 20.0),

            // Separated section for Categories
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ExerciseFilterWidgets(
                data: categoryData,
                isBodyPart: false,
                isCategory: true,
                state: this),
          ],
        ),
      ),
    );
  }

  void showMaxFilterWarning() {
    // Show a warning message when more than 5 filters are selected
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('Maximum Filters Reached',
              style: TextStyle(color: Color(0xFFE1F0CF))),
          content: const Text('You can only select 5 filters.',
              style: TextStyle(color: Color(0xFFC1C1C1))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
