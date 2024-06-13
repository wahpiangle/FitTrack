import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/history/calendar/calendar_button.dart';
import 'package:group_project/pages/history/components/workout_card.dart';
import 'package:group_project/pages/workout/State/timer_sheet_manager.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class HistoryScreen extends StatefulWidget {
  final List<Exercise> exerciseData;

  const HistoryScreen({
    super.key,
    required this.exerciseData,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final AutoScrollController _scrollController = AutoScrollController();

  void scrollToItem(int index) async {
    await _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
    await _scrollController.highlight(index);
  }

  @override
  void initState() {
    super.initState();
    _handleTimerActive(context);
  }

  void _handleTimerActive(BuildContext context) {
    TimerProvider? timerProvider =
        Provider.of<TimerProvider>(context, listen: false);

    void handleTimerStateChanged() {
      if (timerProvider.isTimerRunning &&
          !TimerManager().isTimerActiveScreenOpen) {
        TimerManager().showTimerBottomSheet(context, widget.exerciseData);
      } else if (!timerProvider.isTimerRunning &&
          TimerManager().isTimerActiveScreenOpen) {
        TimerManager().closeTimerBottomSheet(context);
      }
    }

    void Function()? listener;
    listener = () {
      if (mounted) {
        handleTimerStateChanged();
      } else {
        timerProvider.removeListener(listener!);
      }
    };

    timerProvider.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        height: double.infinity,
        color: const Color(0xFF1A1A1A),
        child: StreamBuilder<List<WorkoutSession>>(
          stream: objectBox.workoutSessionService.watchWorkoutSession(),
          builder: (context, snapshot) {
            void getIndexByWorkoutSession(WorkoutSession workoutSession) {
              final index = snapshot.data!
                  .indexWhere((element) => element.id == workoutSession.id);
              scrollToItem(index);
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return snapshot.data!.isEmpty
                  ? const Center(
                      child: Text(
                        'No workout sessions yet!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        CalendarButton(
                          workoutSessions: snapshot.data!,
                          scrollToItem: getIndexByWorkoutSession,
                        ),
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            children: snapshot.data!.map((workoutSession) {
                              return AutoScrollTag(
                                key: ValueKey(workoutSession.id),
                                controller: _scrollController,
                                index: snapshot.data!.indexWhere((element) =>
                                    element.id == workoutSession.id),
                                child: WorkoutCard(
                                  key: Key(workoutSession.id.toString()),
                                  workoutSession: workoutSession,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
            }
          },
        ),
      ),
    );
  }
}
