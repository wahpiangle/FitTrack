import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_provider.dart';

class RestTimePicker extends StatelessWidget {
  final RestTimerProvider restTimerProvider;
  final int initialMinutes;
  final int initialSeconds;

  const RestTimePicker({
    Key? key,
    required this.restTimerProvider,
    required this.initialMinutes,
    required this.initialSeconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the initial item based on minutes and seconds
    int initialItem = ((initialMinutes ?? 0) * 60 + (initialSeconds ?? 0)) ~/ 5;

    return Container(
      height: 300,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: initialItem,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          // Calculate total seconds based on the 5 seconds difference
          int totalSeconds = (index + 1) * 5;

          // Convert total seconds to minutes and seconds for updating the provider
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


