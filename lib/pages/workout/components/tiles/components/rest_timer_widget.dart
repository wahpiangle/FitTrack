import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_provider.dart';

class RestTimerWidget extends StatelessWidget {
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

  const TimerDetailsDialog({Key? key, required this.restTimerProvider}) : super(key: key);

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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    return AlertDialog(
      title: Text("Edit Rest Timer"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Duration: ${formatDuration(widget.restTimerProvider.currentDuration)}"),
          SizedBox(height: 16),
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
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => _showEditDialog(context),
                icon: Icon(Icons.edit, size: 32),
              ),
              IconButton(
                onPressed: () {
                  _timer.cancel();
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, size: 32),
              ),
            ],
          ),
        ],
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
        return AlertDialog(
          title: Text("Edit Timer"),
          content: Column(
            children: [
              Text("Current Duration: ${formatDuration(widget.restTimerProvider.currentDuration)}"),
              TextFormField(
                controller: _editController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Enter New Duration (in seconds)"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                int newDuration = int.tryParse(_editController.text) ?? 0;
                widget.restTimerProvider.resetRestTimer(newDuration);
                Navigator.of(context).pop();
              },
              child: Text("Update"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
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
