import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';

class RestTimePicker extends StatelessWidget {
  final RestTimerProvider restTimerProvider;

  const RestTimePicker({
    super.key,
    required this.restTimerProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust the initial item
    int initialItem = (restTimerProvider.restTimerMinutes * 60 +
                restTimerProvider.restTimerSeconds) ~/
            5 -
        1;

    return Container(
      height: double.infinity,
      color: AppColours.primaryBright,
      child: CupertinoPicker(
        backgroundColor: AppColours.primary,
        scrollController: FixedExtentScrollController(
          initialItem: initialItem,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          int totalSeconds = (index + 1) * 5;
          int minutes = totalSeconds ~/ 60;
          int seconds = totalSeconds % 60;

          restTimerProvider.setRestTimerMinutes(minutes);
          restTimerProvider.setRestTimerSeconds(seconds);
        },
        children: List.generate(15 * 60 ~/ 5, (index) {
          int totalSeconds = (index + 1) * 5;

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


class RestTimerCustom extends StatelessWidget {
  final RestTimerProvider restTimerProvider;

  const RestTimerCustom({
    super.key,
    required this.restTimerProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust the initial item
    int initialItem = (restTimerProvider.restTimerMinutes * 60 +
        restTimerProvider.restTimerSeconds) ~/
        5 -
        1;

    return Container(
      height: double.infinity,
      color: AppColours.primaryBright,
      child: CupertinoPicker(
        backgroundColor: AppColours.primaryBright,
        scrollController: FixedExtentScrollController(
          initialItem: initialItem,
        ),
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          int totalSeconds = (index + 1) * 5;
          int minutes = totalSeconds ~/ 60;
          int seconds = totalSeconds % 60;

          Future.delayed(Duration.zero, () {
            restTimerProvider.setCustomRestTimerMinutes(minutes);
            restTimerProvider.setCustomRestTimerSeconds(seconds);
          });
        },
        children: List.generate(15 * 60 ~/ 5, (index) {
          int totalSeconds = (index + 1) * 5;

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
