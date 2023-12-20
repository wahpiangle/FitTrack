import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_provider.dart';

class RestTimePicker extends StatelessWidget {
  final RestTimerProvider restTimerProvider;

  const RestTimePicker({
    super.key,
    required this.restTimerProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust the initial item
    int initialItem = (restTimerProvider.restTimerMinutes * 60 + restTimerProvider.restTimerSeconds) ~/ 5 - 1;

    return Container(
      height: double.infinity, // Set the desired height
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: initialItem,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          // Adjust the selected item
          int totalSeconds = (index + 1) * 5;
          int minutes = totalSeconds ~/ 60;
          int seconds = totalSeconds % 60;

          restTimerProvider.setRestTimerMinutes(minutes);
          restTimerProvider.setRestTimerSeconds(seconds);
        },
        children: List.generate(15 * 60 ~/ 5, (index) {
          // Calculate total seconds based on the 5 seconds difference
          int totalSeconds = (index + 1) * 5;

          // Convert total seconds to minutes and seconds for display
          int minutes = totalSeconds ~/ 60;
          int seconds = totalSeconds % 60;

          return Center(
            child: Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }),
      ),
    );
  }
}


