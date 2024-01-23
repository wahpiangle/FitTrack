import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';

class RestTimerDialog extends StatefulWidget {
  final Animation<double> animation;
  final int changeTimeSeconds;
  final Timer timer;
  final RestTimerProvider? restTimerProvider;
  final CustomTimerProvider? customTimerProvider;

  const RestTimerDialog({
    super.key,
    required this.animation,
    required this.changeTimeSeconds,
    required this.timer,
    this.restTimerProvider,
    this.customTimerProvider,
  });

  @override
  State<RestTimerDialog> createState() => _RestTimerDialogState();
}

class _RestTimerDialogState extends State<RestTimerDialog> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return Transform.scale(
          alignment: Alignment.center,
          scale: widget.animation.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: AppColours.primary,
              ),
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
                            widget.timer.cancel();
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
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 55),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 230,
                          width: 230,
                          child: CircularProgressIndicator(
                            value: widget.restTimerProvider != null
                                ? widget.restTimerProvider!
                                        .currentRestTimerDuration /
                                    widget.restTimerProvider!.restTimerDuration
                                : widget.customTimerProvider!
                                        .customCurrentTimerDuration /
                                    widget.customTimerProvider!
                                        .customTimerDuration,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFB9D499),
                            ),
                            strokeWidth: 6,
                          ),
                        ),
                        Text(
                          RestTimerProvider.formatDuration(
                            widget.restTimerProvider != null
                                ? widget
                                    .restTimerProvider!.currentRestTimerDuration
                                : widget.customTimerProvider!
                                    .customCurrentTimerDuration,
                          ),
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
                              widget.restTimerProvider != null
                                  ? widget.restTimerProvider!
                                      .adjustRestTime(-widget.changeTimeSeconds)
                                  : widget.customTimerProvider!
                                      .adjustCustomTime(
                                          -widget.changeTimeSeconds);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xFFE1F0CF),
                            ),
                            child: Text('-${widget.changeTimeSeconds}s'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              widget.restTimerProvider != null
                                  ? widget.restTimerProvider!.stopRestTimer()
                                  : widget.customTimerProvider!
                                      .stopCustomTimer();
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
                              widget.restTimerProvider != null
                                  ? widget.restTimerProvider!
                                      .adjustRestTime(widget.changeTimeSeconds)
                                  : widget.customTimerProvider!
                                      .adjustCustomTime(
                                          widget.changeTimeSeconds);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xFFE1F0CF),
                            ),
                            child: Text('+${widget.changeTimeSeconds}s'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
