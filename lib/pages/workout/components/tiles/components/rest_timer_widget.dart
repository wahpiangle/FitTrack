import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_provider.dart';

class RestTimerWidget extends StatelessWidget {
  const RestTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestTimerProvider>(
      builder: (context, restTimerProvider, child) {
        if (restTimerProvider.isTimerRunning) {
          return GestureDetector(
            onTap: () {
              _showTimerDetailsDialog(context, restTimerProvider);
            },
            child: Text(
              "Rest Timer: ${formatDuration(restTimerProvider.currentDuration)}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void _showTimerDetailsDialog(
      BuildContext context, RestTimerProvider restTimerProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimerDetailsDialog(
          restTimerProvider: restTimerProvider,
        );
      },
    );
  }

  String formatDuration(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$remainingSeconds";
  }
}





class TimerDetailsDialog extends StatefulWidget {
  final RestTimerProvider restTimerProvider;

  const TimerDetailsDialog({super.key, required this.restTimerProvider});

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
                  icon: const Icon(Icons.close, size: 32, color: Color(0xFFC1C1C1)), // Icon color
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
              "${formatDuration(widget.restTimerProvider.currentDuration)}",
              style: const TextStyle(
                color: Color(0xFFE1F0CF), // White color for text
                fontSize: 64, // Enlarge the font size
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    if (widget.restTimerProvider.isPaused) {
                      _resumeTimer();
                    } else {
                      _pauseTimer();
                    }
                  },
                  icon: Icon(
                    widget.restTimerProvider.isPaused ? Icons.play_arrow : Icons.pause,
                    size: 32,
                    color: const Color(0xFFC1C1C1), // Icon color
                  ),
                ),
                IconButton(
                  onPressed: () => _showEditDialog(context),
                  icon: const Icon(Icons.edit, size: 32, color: Color(0xFFC1C1C1)), // Icon color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _pauseTimer() {
    widget.restTimerProvider.pauseTimer();
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeTimer() {
    widget.restTimerProvider.resumeTimer();
    setState(() {
      _isPaused = false;
    });
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                const Text(
                  "Edit Timer",
                  style: TextStyle(
                    color: Color(0xFFE1F0CF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Current Duration: ${formatDuration(widget.restTimerProvider.currentDuration)}",
                  style: const TextStyle(
                    color: Color(0xFFE1F0CF),
                    fontSize: 16,
                  ),
                ),
                TextFormField(
                  controller: _editController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter New Duration (in seconds)",
                    labelStyle: TextStyle(color: Color(0xFFC1C1C1)),
                  ),
                  style: const TextStyle(color: Color(0xFFE1F0CF)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        int newDuration = int.tryParse(_editController.text) ?? 0;
                        widget.restTimerProvider.resetRestTimer(newDuration,context);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE1F0CF), // Button background color
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(color: Color(0xFF1A1A1A)), // Button text color
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Color(0xFFE1F0CF)), // Button text color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDuration(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$remainingSeconds";
  }
}


