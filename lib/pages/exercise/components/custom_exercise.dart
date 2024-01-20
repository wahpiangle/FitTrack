import 'package:flutter/material.dart';
import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/bodypart_data.dart';
import '../../../models/body_part.dart';
import '../../../models/category.dart';
import '../../../models/exercise.dart';
import '../../../services/objectbox_service.dart';

class CustomExerciseDialog {
  static void showNewExerciseDialog(BuildContext context, ObjectBox objectBox) {
    String? customWorkoutName;
    String? selectedBodyPart;
    String? selectedCategory;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A1A),
          title: (selectedBodyPart == null && selectedCategory == null)
              ? Text(
            'Custom Exercise',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold, // Set fontWeight to bold
            ),
          )
              : null,
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      onChanged: (value) {
                        customWorkoutName = value;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'add name...',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Color of the underline
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Color of the focused underline
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red), // Color of the error underline
                        ),
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a workout name';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: selectedBodyPart,
                    onChanged: (String? newValue) {
                      selectedBodyPart = newValue;
                    },
                    items: bodyPartData.map<DropdownMenuItem<String>>((BodyPart bodyPart) {
                      return DropdownMenuItem<String>(
                        value: bodyPart.name,
                        child: Text(
                          bodyPart.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Body Part',
                      labelStyle: TextStyle(color: Colors.white),
                      isDense: true,
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    dropdownColor: Color(0xFF1A1A1A),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      selectedCategory = newValue;
                    },
                    items: categoryData.map<DropdownMenuItem<String>>((Category category) {
                      return DropdownMenuItem<String>(
                        value: category.name,
                        child: Text(
                          category.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      labelStyle: TextStyle(color: Colors.white),
                      isDense: false,
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    dropdownColor: Color(0xFF1A1A1A),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(0.0), // Adjusted bottomRight radius
                          ),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: Color(0xFF1A1A1A), width: 1.0)),
                        ),
                        child: Text('Cancel', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0), // Added spacing between Cancel and Save
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          String selectedBodyPartText =
                          selectedBodyPart != null ? 'Selected Body Part: $selectedBodyPart' : 'No Body Part Selected';
                          String selectedCategoryText =
                          selectedCategory != null ? 'Selected Category: $selectedCategory' : 'No Category Selected';
                          String customWorkoutNameText =
                          customWorkoutName != null ? 'Custom Workout Name: $customWorkoutName' : 'No Workout Name Entered';

                          print(selectedBodyPartText);
                          print(selectedCategoryText);
                          print(customWorkoutNameText);

                          // Create an Exercise object with the entered data
                          Exercise newExercise = Exercise(
                            name: customWorkoutName ?? '',
                            bodyPart: selectedBodyPart ?? '', // Provide default value if null
                            category: selectedCategory ?? '',
                          );

                          // Use the ObjectBox instance to add the exercise to the list
                          objectBox.addExerciseToList(newExercise);
                          Navigator.pop(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0), // Adjusted bottomLeft radius
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        backgroundColor: Color(0xFFE1F0CF), // Background color (border fill)
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: Color(0xFFE1F0CF), width: 1.0)),
                        ),
                        child: Text('Save', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
