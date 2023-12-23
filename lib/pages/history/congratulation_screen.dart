import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:confetti/confetti.dart';

import 'components/complete_workout_card.dart';


class CongratulationScreen extends StatefulWidget {
  const CongratulationScreen({Key? key});

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  final AutoScrollController _scrollController = AutoScrollController();
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


  void scrollToItem(int index) async {
    await _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
    await _scrollController.highlight(index);
  }

  void _delete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Save as Workout Template?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'FitTrack can save this workout as a workout template so you can perform it again easily in the future.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                // direct to save template
              },
              child: const Text(
                'Save as Workout Template',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              //Navigate to share feature
            },
          )
        ],
          leading: IconButton(
          onPressed: () {},
            icon: IconButton(
              icon:const Icon(Icons.close_sharp),
              onPressed:  () {
                _delete(context);
              },
            ),
          ),

      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
        child: StreamBuilder<List<WorkoutSession>>(
          stream: objectBox.workoutSessionService.watchWorkoutSession(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(); // Adjust this part if needed
            } else {
              int workoutNumber = snapshot.data!.length; // Assuming workout number is based on the length of the list

              _celebrate();

              return const Column(
                children: [
                  
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
