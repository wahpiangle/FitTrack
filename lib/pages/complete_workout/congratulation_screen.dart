import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/complete_workout/components/template_dialog.dart';
import 'package:confetti/confetti.dart';
import 'complete_workout_card.dart';

class CongratulationScreen extends StatefulWidget {
  final WorkoutSession? workoutSession;

  const CongratulationScreen({
    super.key,
    this.workoutSession,
  });

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  final ConfettiController _confettiController = ConfettiController();

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _celebrate() {
    _confettiController.play();
    Timer(const Duration(seconds: 1), () {
      _confettiController.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    _celebrate();
    int workoutNumber =
        objectBox.workoutSessionService.getAllWorkoutSessions().length;
    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          Future.delayed(Duration.zero, () {
            Navigator.pushNamed(
              context,
              'post_workout_prompt',
            );
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return TemplateDialog(
                    workoutSession: widget.workoutSession!,
                  );
                },
              );
            },
            icon: const Icon(Icons.close_sharp, color: Colors.white),
          ),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                  ],
                  gravity: 0.1,
                  emissionFrequency: 0.1,
                ),
              ),
              Image.asset(
                'assets/icons/stars1.png',
                width: 150,
                height: 100,
                fit: BoxFit.cover,
              ),
              const Center(
                child: Text(
                  'Congratulations!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  'That\'s your workout number $workoutNumber!',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              CompleteWorkoutCard(
                workoutSession: widget.workoutSession!,
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
