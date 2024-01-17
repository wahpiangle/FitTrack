import 'package:flutter/material.dart';
import 'package:group_project/pages/exercise/exercise_filter_page.dart';

class ExercisesListFilters extends StatelessWidget {
  final void Function(String query) filterExercises;
  final String selectedBodyPart;
  final void Function(String bodyPart) setSelectedBodyPart;
  final List<String> selectedCategory;
  final void Function(String category) addSelectedCategory;
  final void Function(String category) removeSelectedCategory;

  const ExercisesListFilters({
    super.key,
    required this.filterExercises,
    required this.selectedBodyPart,
    required this.setSelectedBodyPart,
    required this.selectedCategory,
    required this.addSelectedCategory,
    required this.removeSelectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: const Color(0xFF333333)),
                      color: const Color(0xFF333333),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: const Color(0xFF333333)),
                      ),
                      child: TextField(
                        onChanged: (query) {
                          filterExercises(query);
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Search exercise...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: const Color(0xFF333333)),
                      color: const Color(0xFF333333),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list,
                          color: Colors.white, size: 24.0),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ExerciseFilterPage(
                                selectedBodyPart: selectedBodyPart,
                                setBodyPart: (bodyPart) =>
                                    setSelectedBodyPart(bodyPart),
                                selectedCategory: selectedCategory,
                                addCategory: (category) =>
                                    addSelectedCategory(category),
                                removeCategory: (category) =>
                                    removeSelectedCategory(category),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
