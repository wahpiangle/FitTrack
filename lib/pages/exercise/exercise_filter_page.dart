import 'package:flutter/material.dart';
import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/bodypart_data.dart';

class ExerciseFilterPage extends StatefulWidget {
  final Function(dynamic bodyPart) setBodyPart;
  final String selectedBodyPart;
  final List<String> selectedCategory;
  final Function(dynamic category) addCategory;
  final Function(dynamic category) removeCategory;

  ExerciseFilterPage({
    Key? key,
    required this.setBodyPart,
    required this.selectedBodyPart,
    required this.selectedCategory,
    required this.addCategory,
    required this.removeCategory,
  });

  @override
  _ExerciseFilterPageState createState() => _ExerciseFilterPageState();
}

class _ExerciseFilterPageState extends State<ExerciseFilterPage> {
  String selectedBodyPart = '';
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    selectedCategories = widget.selectedCategory;
    selectedBodyPart = widget.selectedBodyPart;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Filter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            generateItems(bodyPartData, true, false),
            const SizedBox(height: 20.0),

            // Separated section for Categories
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            generateItems(categoryData, false, true),
          ],
        ),
      ),
    );
  }

  Widget generateItems(
      List data,
      bool isBodyPart,
      bool isCategory,
      ) {
    if (isBodyPart) {
      return Wrap(
        spacing: 12,
        runSpacing: 20,
        children: data.map((bodyPart) {
          bool isFilterSelected = selectedBodyPart == bodyPart.name;
          return generateColoredBorderItem(
            isFilterSelected,
            const Color(0xFFE1F0CF), // Green border color (#E1F0CF)
            18,
            bodyPart.name,
                () {
              setState(() {
                if (isFilterSelected) {
                  selectedBodyPart = '';
                  widget.setBodyPart('');
                } else {
                  selectedBodyPart = bodyPart.name;
                  widget.setBodyPart(bodyPart.name);
                }
              });
            },
          );
        }).toList(),
      );
    } else if (isCategory) {
      return Wrap(
        spacing: 12,
        runSpacing: 20,
        children: data.map((category) {
          final isFilterSelected = selectedCategories.contains(category.name);
          return generateColoredBorderItem(
            isFilterSelected,
            const Color(0xFFE1F0CF), // Green border color (#E1F0CF)
            18,
            category.name,
                () {
              setState(() {
                if (isFilterSelected) {
                  widget.removeCategory(category.name);
                } else {
                  widget.addCategory(category.name);
                }
              });
            },
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }

  Widget generateColoredBorderItem(
      bool isFilterSelected,
      Color selectedColor,
      double fontSize,
      String text,
      Function() onTap,
      ) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: isFilterSelected
              ? selectedColor
              : const Color.fromARGB(255, 46, 46, 46),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24.0),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isFilterSelected ? Colors.black : Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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
