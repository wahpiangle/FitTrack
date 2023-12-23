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
  late TextEditingController _editController;
  late int _currentDuration;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
    _currentDuration = widget.restTimerProvider.currentDuration;
    _startUpdatingTimer();
  }

  void _startUpdatingTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentDuration = widget.restTimerProvider.currentDuration;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: const Color(0xFF1A1A1A), // Grey background color
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
                      size: 32, color: Color(0xFFC1C1C1)), // Icon color
                ),
              ],
            ),
            const Text(
              "Rest Timer",
              style: TextStyle(
                color: Color(0xFFE1F0CF), // White color for text
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "${TimerProvider.formatDuration(widget.restTimerProvider.currentDuration)}",
              style: const TextStyle(
                color: Color(0xFFE1F0CF), // White color for text
                fontSize: 64, // Enlarge the font size
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditTimerDialog(
          restTimerProvider: widget.restTimerProvider,
        );
      },
    );
  }
}

class EditTimerDialog extends StatelessWidget {
  final RestTimerProvider restTimerProvider;

  const EditTimerDialog({Key? key, required this.restTimerProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the edit timer dialog here
    // Use the restTimerProvider to access the rest timer details
    return Container();
  }
}
