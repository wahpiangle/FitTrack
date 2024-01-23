import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/components/rest_timer_dialog.dart';

class CustomTimerDetailsDialog extends StatefulWidget {
  final CustomTimerProvider customTimerProvider;

  const CustomTimerDetailsDialog(
      {super.key, required this.customTimerProvider});

  @override
  CustomTimerDetailsDialogState createState() =>
      CustomTimerDetailsDialogState();
}

class CustomTimerDetailsDialogState extends State<CustomTimerDetailsDialog>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final int _changeTimeSeconds = 10; //TODO: set this based on user settings

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
    return RestTimerDialog(
      animation: _animation,
      changeTimeSeconds: _changeTimeSeconds,
      timer: _timer,
      customTimerProvider: widget.customTimerProvider,
    );
  }
}
