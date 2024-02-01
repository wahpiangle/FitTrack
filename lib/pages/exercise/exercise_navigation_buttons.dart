import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/exercise_detail.dart';
import 'package:group_project/pages/exercise/exercise_history.dart';
import 'package:group_project/pages/exercise/exercise_charts.dart';
import 'package:group_project/pages/exercise/exercise_records.dart';
import '../../constants/themes/app_colours.dart';

class NavigationButtonsRow extends StatelessWidget {
  final int selectedPageIndex;
  final Exercise exercise;

  NavigationButtonsRow({
    required this.selectedPageIndex,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavigationButton(
            pageIndex: 0,
            selectedPageIndex: selectedPageIndex,
            buttonText: 'About',
            destination: ExerciseDetailScreen(
              exercise,
              key: PageStorageKey('exerciseDetailScreen'),
            ),
          ),
          NavigationButton(
            pageIndex: 1,
            selectedPageIndex: selectedPageIndex,
            buttonText: 'History',
            destination: ExerciseHistory(
              exercise,
              key: PageStorageKey('exerciseHistory'),
            ),
          ),
          NavigationButton(
            pageIndex: 2,
            selectedPageIndex: selectedPageIndex,
            buttonText: 'Charts',
            destination: ExerciseCharts(
              exercise,
              key: PageStorageKey('exerciseCharts'),
            ),
          ),
          NavigationButton(
            pageIndex: 3,
            selectedPageIndex: selectedPageIndex,
            buttonText: 'Records',
            destination: ExerciseRecords(
              exercise,
              key: PageStorageKey('exerciseRecords'),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final int pageIndex;
  final int selectedPageIndex;
  final String buttonText;
  final Widget destination;

  NavigationButton({
    required this.pageIndex,
    required this.selectedPageIndex,
    required this.buttonText,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (selectedPageIndex != pageIndex) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return destination;
              },
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedPageIndex == pageIndex
            ? const Color(0xFF555555)
            : const Color(0xFF333333),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: AppColours.secondary,
        ),
      ),
    );
  }
}
