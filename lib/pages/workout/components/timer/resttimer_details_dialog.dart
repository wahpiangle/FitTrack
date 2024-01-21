import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';
import 'custom_timer_provider.dart';


class RestTimerDetailsDialog extends StatefulWidget {
  final RestTimerProvider restTimerProvider;

  const RestTimerDetailsDialog({super.key, required this.restTimerProvider});


  @override
  RestTimerDetailsDialogState createState() => RestTimerDetailsDialogState();
}

class RestTimerDetailsDialogState extends State<RestTimerDetailsDialog>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _startUpdatingTimer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Delay the notification to the end of the build phase
    Future.delayed(Duration.zero, () {
      widget.restTimerProvider.showRestDialog();
    });

    _animationController.forward();
  }

  void _startUpdatingTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    Future.delayed(Duration.zero, () {
      widget.restTimerProvider.closeRestDialog();
    });
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          alignment: Alignment.center,
          scale: _animation.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
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
                          width: 230,
                          height: 230,
                          child: CircularProgressIndicator(
                            value: widget.restTimerProvider.currentRestTimerDuration /
                                widget.restTimerProvider.restTimerDuration,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFB9D499),),
                            strokeWidth: 6,
                          ),
                        ),
                        Text(
                          RestTimerProvider.formatDuration(
                              widget.restTimerProvider.currentRestTimerDuration),
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
            ),
          ),
        );
      },
    );
  }
}




class CustomTimerDetailsDialog extends StatefulWidget {
  final CustomTimerProvider customTimerProvider;

  const CustomTimerDetailsDialog({super.key, required this.customTimerProvider});


  @override
  CustomTimerDetailsDialogState createState() => CustomTimerDetailsDialogState();
}

class CustomTimerDetailsDialogState extends State<CustomTimerDetailsDialog>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _startUpdatingTimer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Delay the notification to the end of the build phase
    Future.delayed(Duration.zero, () {
      widget.customTimerProvider.showCustomDialog(context);
    });

    _animationController.forward();
  }

  void _startUpdatingTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    Future.delayed(Duration.zero, () {
      widget.customTimerProvider.closeRestDialog();
    });
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          alignment: Alignment.center,
          scale: _animation.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
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
                            _timer.cancel();
                            Navigator.of(context).pop();
                            },
                          icon: const Icon(Icons.close,
                              size: 32, color: Color(0xFFC1C1C1)),
                        ),
                      ],
                    ),
                    const Text(
                      "Custom Timer",
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
                          width: 230,
                          height: 230,
                          child: CircularProgressIndicator(
                            value: widget.customTimerProvider.customCurrentTimerDuration /
                                widget.customTimerProvider.customTimerDuration,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFB9D499),),
                            strokeWidth: 6,
                          ),
                        ),
                        Text(
                          RestTimerProvider.formatDuration(
                              widget.customTimerProvider.customCurrentTimerDuration),
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
                              widget.customTimerProvider.adjustCustomTime(-10);
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
                              widget.customTimerProvider.stopCustomTimer();
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
                              widget.customTimerProvider.adjustCustomTime(10);
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
            ),
          ),
        );
      },
    );
  }
}

void showAboutRestTimerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:  AppColours.primaryBright, // Grey background color
        title: const Center(
          child: Text(
            'About Rest Timer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content:const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Manually set a Custom Rest Timer at any time.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Auto Rest Timers can be set up to start when a set is completed.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              Text(
                'To set the Auto Rest Timer duration, navigate to Settings >> Timer >> Rest Duration.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(
                fontSize: 18,
                color: AppColours.secondary,
              ),
            ),
          ),
        ],
      );
    },
  );
}
