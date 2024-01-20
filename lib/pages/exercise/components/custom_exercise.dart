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
          backgroundColor: const Color(0xFF1A1A1A),
          title: (selectedBodyPart == null && selectedCategory == null)
              ? const Text(
            'Custom Exercise',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
              : null,
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      onChanged: (value) {
                        customWorkoutName = value;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'add name...',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
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

                  const SizedBox(height: 16.0),
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
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Select Body Part',
                      labelStyle: TextStyle(color: Colors.white),
                      isDense: true,
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    dropdownColor: const Color(0xFF1A1A1A),
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
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Select Category',
                      labelStyle: TextStyle(color: Colors.white),
                      isDense: false,
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    dropdownColor: const Color(0xFF1A1A1A),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Container(
              decoration: const BoxDecoration(
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
                        padding: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(0.0),
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: Color(0xFF1A1A1A), width: 1.0)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          if (selectedBodyPart == null || selectedCategory == null) {
                            // Display a warning message if either body part or category is not selected
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select both Body Part and Category before saving.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // Create an Exercise object with the entered data
                            Exercise newExercise = Exercise(
                              name: customWorkoutName ?? '',
                              bodyPart: selectedBodyPart ?? '',
                              category: selectedCategory ?? '',
                            );

                            // Use the ObjectBox instance to add the exercise to the list
                            objectBox.addExerciseToList(newExercise, selectedCategory, selectedBodyPart);
                            Navigator.pop(context);
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(8.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        backgroundColor: const Color(0xFFE1F0CF),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          border: Border(left: BorderSide(color: Color(0xFFE1F0CF), width: 1.0)),
                        ),
                        child: const Text('Save', style: TextStyle(color: Colors.black)),
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
