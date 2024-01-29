import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';

class TimePicker extends StatelessWidget {
  final RestTimerProvider? restTimerProvider;
  final CustomTimerProvider? customTimerProvider;
  const TimePicker({
    super.key,
    this.restTimerProvider,
    this.customTimerProvider,
  });

  @override
  Widget build(BuildContext context) {
    int initialItem = customTimerProvider == null
        ? (restTimerProvider!.restTimerMinutes * 60 +
                    restTimerProvider!.restTimerSeconds) ~/
                5 -
            1
        : (customTimerProvider!.customTimerMinutes * 60 +
                    customTimerProvider!.customTimerSeconds) ~/
                5 -
            1;
    return Container(
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

          if (restTimerProvider != null) {
            restTimerProvider!.setRestTimerMinutes(minutes);
            restTimerProvider!.setRestTimerSeconds(seconds);
          } else {
            customTimerProvider!.setCustomTimerMinutes(minutes);
            customTimerProvider!.setCustomTimerSeconds(seconds);
          }
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
