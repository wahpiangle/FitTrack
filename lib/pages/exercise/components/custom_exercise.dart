import 'package:flutter/material.dart';
import 'package:group_project/constants/data/category_data.dart';
import 'package:group_project/constants/data/bodypart_data.dart';
import 'package:group_project/models/body_part.dart';
import 'package:group_project/models/category.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/services/objectbox_service.dart';

class CustomExerciseDialog {
  static void showNewExerciseDialog(BuildContext context, ObjectBox objectBox) {
    String? customExerciseName;
    BodyPart selectedBodyPart = bodyPartData[0];
    Category selectedCategory = categoryData[0];
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: const Color(0xFF1A1A1A),
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Custom Exercise',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        customExerciseName = value;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Exercise Name',
                        hintStyle: TextStyle(color: Colors.grey),
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
                  DropdownButtonFormField<BodyPart>(
                    value: selectedBodyPart,
                    onChanged: (BodyPart? newValue) {
                      if (newValue != null) {
                        selectedBodyPart = newValue;
                      }
                    },
                    items: bodyPartData.map((BodyPart bodyPart) {
                      return DropdownMenuItem<BodyPart>(
                        value: bodyPart,
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
                  DropdownButtonFormField<Category>(
                    value: selectedCategory,
                    onChanged: (Category? newValue) {
                      if (newValue != null) {
                        selectedCategory = newValue;
                      }
                    },
                    items: categoryData.map<DropdownMenuItem<Category>>((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
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
                          border: Border(
                              right: BorderSide(
                                  color: Color(0xFF1A1A1A), width: 1.0)),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          if (customExerciseName == null) {
                            // Display a warning message if either body part or category is not selected
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Exercise name cannot be empty!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            Exercise newExercise = Exercise(
                              name: customExerciseName ?? '',
                            );

                            objectBox.addExerciseToList(
                              newExercise,
                              selectedCategory,
                              selectedBodyPart,
                            );
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
                          border: Border(
                              left: BorderSide(
                                  color: Color(0xFFE1F0CF), width: 1.0)),
                        ),
                        child: const Text('Save',
                            style: TextStyle(color: Colors.black)),
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
