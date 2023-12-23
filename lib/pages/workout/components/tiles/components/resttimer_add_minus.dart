import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/components/tiles/components/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_provider.dart';


class TimerDetailsDialog extends StatefulWidget {
  final RestTimerProvider restTimerProvider;

  const TimerDetailsDialog({Key? key, required this.restTimerProvider})
      : super(key: key);

  @override
  _TimerDetailsDialogState createState() => _TimerDetailsDialogState();
}

class _TimerDetailsDialogState extends State<TimerDetailsDialog> {
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
      backgroundColor: const Color(0xFF1A1A1A),
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
                  icon: const Icon(Icons.close, size: 32, color: Color(0xFFC1C1C1)),
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
            const SizedBox(height: 76),
            Text(
              "${TimerProvider.formatDuration(widget.restTimerProvider.currentDuration)}",
              style: const TextStyle(
                color: Color(0xFFE1F0CF),
                fontSize: 64,
              ),
            ),
            const SizedBox(height: 76),
            Padding(
              padding: const EdgeInsets.only(bottom: 36.0), // Add padding only at the bottom
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Reduce the rest time by 10 seconds
                      widget.restTimerProvider.adjustRestTime(-10);
                    },
                    child: const Text('-10s'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Increase the rest time by 10 seconds
                      widget.restTimerProvider.adjustRestTime(10);
                    },
                    child: const Text('+10s'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // End the whole rest timer
                      widget.restTimerProvider.stopRestTimer();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Skip'),
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
