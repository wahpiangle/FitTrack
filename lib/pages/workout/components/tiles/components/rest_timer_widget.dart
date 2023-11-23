import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_provider.dart';

class RestTimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RestTimerProvider>(
      builder: (context, restTimerProvider, child) {
        if (restTimerProvider.isTimerRunning) {
          return Text(
            "Rest Timer: ${formatDuration(restTimerProvider.currentDuration)}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          );
        } else {
          return const SizedBox.shrink(); // Hide the widget when the timer is not running
        }
      },
    );
  }

  String formatDuration(int seconds) {
    print("Current Duration: $seconds");
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$remainingSeconds";
  }
}
