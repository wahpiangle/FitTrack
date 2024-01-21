import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';

import '../workout/components/timer/rest_time_picker.dart';

class TimerDetailsSettings extends StatelessWidget {
  const TimerDetailsSettings({
    super.key,
  });

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
        color: const Color(0xFF1A1A1A),
        padding: const EdgeInsets.all(16.0),
        child: Consumer<RestTimerProvider>(
          builder: (context, restTimerProvider, child) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
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
                        activeTrackColor: AppColours.secondaryDark,
                        activeColor: const Color(0xFFE1F0CF),
                        inactiveThumbColor: const Color(0xFFC1C1C1),
                        inactiveTrackColor: const Color(0xFF4D4D4D),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
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
                          await _showScrollRestPicker(
                              context, restTimerProvider);
                        },
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showScrollRestPicker(
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
