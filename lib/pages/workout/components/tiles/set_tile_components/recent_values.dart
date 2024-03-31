import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_project/models/exercises_sets_info.dart';

class RecentValues extends StatefulWidget {
  final bool isCurrentEditing;
  final ExercisesSetsInfo exercisesSetsInfo;
  final bool isTapped;
  final Function(
          ExercisesSetsInfo exercisesSetsInfo, AnimationController controller)
      onTapPreviousTab;
  final int? recentWeight;
  final int? recentReps;
  const RecentValues({
    super.key,
    required this.isCurrentEditing,
    required this.exercisesSetsInfo,
    required this.isTapped,
    required this.onTapPreviousTab,
    required this.recentWeight,
    required this.recentReps,
  });
  @override
  State<RecentValues> createState() => _RecentValuesState();
}

class _RecentValuesState extends State<RecentValues>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          widget.onTapPreviousTab(
            widget.exercisesSetsInfo,
            _controller,
          );
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                CurveTween(curve: const SineCurve())
                        .transform(_controller.value) *
                    1,
                0.0,
              ),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.recentWeight != null
                  ? '${widget.recentWeight}kg x ${widget.recentReps}'
                  : '-',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: widget.isTapped ? Colors.grey : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class SineCurve extends Curve {
  const SineCurve({this.count = 3});
  final double count;

  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}
