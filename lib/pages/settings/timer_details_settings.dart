import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';

import '../workout/components/timer/rest_time_picker.dart';


class TimerDetailsSettings extends StatelessWidget {
  const TimerDetailsSettings({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(
        pageIndex: 0,
        title: 'Timer Details',
        user: null,
        showBackButton: true,
      ),
      body: Container(
        color: const Color(0xFF1A1A1A), // Set the background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rest Timer
            Consumer<RestTimerProvider>(
              builder: (context, restTimerProvider, child) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850], // box background color
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Rest Timer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Switch(
                                  value: restTimerProvider.isRestTimerEnabled,
                                  onChanged: (value) {
                                    if (value) {
                                      restTimerProvider.startRestTimer(context);
                                    } else {
                                      restTimerProvider.stopRestTimer();
                                    }
                                    restTimerProvider.toggleRestTimer(value);
                                  },
                                  activeTrackColor: const Color(0xFFB3BFA5), // Set the active track color
                                  activeColor: const Color(0xFFE1F0CF), // Set the active color
                                  inactiveThumbColor: const Color(0xFFC1C1C1), // Set the inactive thumb color
                                  inactiveTrackColor: const Color(0xFFC1C1C1), // Set the inactive track color
                                ),
                              ],
                            ),
                            // Add more settings components as needed
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850], // box background color
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Rest Duration',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _showScrollTimePicker(context, restTimerProvider);
                                  },
                                  child: const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showScrollTimePicker(
      BuildContext context, RestTimerProvider restTimerProvider) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 800,
          child: RestTimePicker(restTimerProvider: restTimerProvider),
        );
      },
    );
  }
}

