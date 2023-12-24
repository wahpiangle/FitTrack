import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';

class RestTimerDetailsDialog extends StatefulWidget {
  final RestTimerProvider restTimerProvider;

  const RestTimerDetailsDialog({super.key, required this.restTimerProvider});

  @override
  RestTimerDetailsDialogState createState() => RestTimerDetailsDialogState();
}

class RestTimerDetailsDialogState extends State<RestTimerDetailsDialog> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startUpdatingTimer();
  }

  void _startUpdatingTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      surfaceTintColor: AppColours.primary,
      backgroundColor: AppColours.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    _timer.cancel();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close,
                      size: 32, color: Color(0xFFC1C1C1)),
                ),
              ],
            ),
            const Text(
              "Rest Timer",
              style: TextStyle(
                color: Color(0xFFE1F0CF),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 55),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 230,
                  height: 230,
                  child: CircularProgressIndicator(
                    value: widget.restTimerProvider.currentDuration /
                        widget.restTimerProvider.restTimerDuration,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                    strokeWidth: 6,
                  ),
                ),
                Text(
                  TimerProvider.formatDuration(
                      widget.restTimerProvider.currentDuration),
                  style: const TextStyle(
                    color: Color(0xFFE1F0CF),
                    fontSize: 64,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(bottom: 36.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.restTimerProvider.adjustRestTime(-10);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFE1F0CF),
                    ),
                    child: const Text('-10s'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // End the whole rest timer
                      widget.restTimerProvider.stopRestTimer();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFC1C1C1),
                    ),
                    child: const Text('Skip'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Increase the rest time by 10 seconds
                      widget.restTimerProvider.adjustRestTime(10);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFE1F0CF),
                    ),
                    child: const Text('+10s'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
