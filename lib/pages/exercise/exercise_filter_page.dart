import 'package:flutter/material.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/bodypart_data.dart';

class FilterArguments {
  final String selectedCategory;
  final String selectedBodyPart;

  FilterArguments(this.selectedCategory, this.selectedBodyPart);
}

class ExerciseFilterPage extends StatefulWidget {
  final List<Category> categories;
  final String selectedCategory;
  final ValueChanged<FilterArguments> onFilterApplied;

  ExerciseFilterPage({
    required this.categories,
    required this.selectedCategory,
    required this.onFilterApplied,
  });

  @override
  _ExerciseFilterPageState createState() => _ExerciseFilterPageState();
}

class _ExerciseFilterPageState extends State<ExerciseFilterPage> {
  List<String> selectedBodyParts = [];
  List<String> selectedCategories = [];
  int selectedFiltersCount = 0; // Add a variable to track the selected filters count

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxGreenBordersPerRow = 3; // Maximum 3 green borders per row
    final borderSpacing = 8.0;
    final itemWidth = (screenWidth - (borderSpacing * (maxGreenBordersPerRow + 1))) / maxGreenBordersPerRow;
    final fontSize = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Filter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Body Parts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              spacing: borderSpacing,
              runSpacing: borderSpacing,
              children: bodyPartData.map((bodyPart) {
                final isFilterSelected = selectedBodyParts.contains(bodyPart.name);
                return generateColoredBorderItem(
                  itemWidth,
                  isFilterSelected,
                  Color(0xFF7E7F7A), // Grey border color
                  const Color(0xFFE1F0CF), // Green border color (#E1F0CF)
                  fontSize,
                  bodyPart.name,
                      () {
                    setState(() {
                      if (isFilterSelected) {
                        selectedBodyParts.remove(bodyPart.name);
                        selectedFiltersCount--; // Decrement the count
                      } else if (selectedFiltersCount < 5) {
                        selectedBodyParts.add(bodyPart.name);
                        selectedFiltersCount++; // Increment the count
                      } else {
                        // Show a warning message if more than 5 filters are selected
                        showMaxFilterWarning();
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),

            // Display selected body parts with grey borders
            if (selectedBodyParts.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Wrap(
                  spacing: borderSpacing,
                  runSpacing: borderSpacing,
                  children: generateGreyBorderItems(selectedBodyParts, itemWidth, fontSize),
                ),
              ),

            // Separated section for Categories
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              spacing: borderSpacing,
              runSpacing: borderSpacing,
              children: categoryData.map((category) {
                final isFilterSelected = selectedCategories.contains(category.name);
                return generateColoredBorderItem(
                  itemWidth,
                  isFilterSelected,
                  Color(0xFF7E7F7A), // Grey border color
                  const Color(0xFFE1F0CF), // Green border color (#E1F0CF)
                  fontSize,
                  category.name,
                      () {
                    setState(() {
                      if (isFilterSelected) {
                        selectedCategories.remove(category.name);
                        selectedFiltersCount--; // Decrement the count
                      } else if (selectedFiltersCount < 5) {
                        selectedCategories.add(category.name);
                        selectedFiltersCount++; // Increment the count
                      } else {
                        // Show a warning message if more than 5 filters are selected
                        showMaxFilterWarning();
                      }
                    });
                  },
                );
              }).toList(),
            ),

            // Display selected categories with grey borders
            if (selectedCategories.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Wrap(
                  spacing: borderSpacing,
                  runSpacing: borderSpacing,
                  children: generateGreyBorderItems(selectedCategories, itemWidth, fontSize),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget generateColoredBorderItem(
      double width,
      bool isFilterSelected,
      Color borderColor,
      Color backgroundColor,
      double fontSize,
      String text,
      Function() onTap,
      ) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: isFilterSelected ? Colors.yellow : borderColor,
          width: 2.0, // You can adjust this width as needed
        ),
        borderRadius: BorderRadius.circular(12.0),
        color: isFilterSelected ? const Color(0xFFF9E076) : backgroundColor,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF1A1A1A), // Font color (#8E9090)
              fontSize: fontSize,
              fontWeight: isFilterSelected ? FontWeight.bold : FontWeight.normal, // Make the text bold inside the green borders
            ),
          ),
        ),
      ),
    );
  }


  List<Widget> generateGreyBorderItems(List<String> items, double itemWidth, double fontSize) {
    List<Widget> greyBorders = [];
    final itemPadding = 8.0; // Padding inside the grey border
    final greyBorderColor = Color(0xFF7E7F7A); // Grey border color
    final greyBackgroundColor = Color(0xFF7E7F7A); // Grey background color
    final fontColor = Color(0xFFDDDDDD); // Font color

    for (int i = 0; i < items.length; i++) {
      greyBorders.add(
        Container(
          width: itemWidth,
          decoration: BoxDecoration(
            border: Border.all(
              color: greyBorderColor,
              width: 2.0, // Match the width of the green borders
            ),
            borderRadius: BorderRadius.circular(12.0),
            color: greyBackgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(itemPadding),
            child: Text(
              items[i],
              style: TextStyle(
                color: fontColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    return greyBorders;
  }


  void showMaxFilterWarning() {
    // Show a warning message when more than 5 filters are selected
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Maximum Filters Reached'),
          content: Text('You can select up to 5 filters.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
