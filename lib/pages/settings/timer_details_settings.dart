import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';

class TimerDetailsSettings extends StatelessWidget {
  const TimerDetailsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(
        pageIndex: 0, // Set the appropriate page index
        title: 'Timer Details', // Set the appropriate title
        user: null, // Set the user accordingly
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add your timer details settings UI components here
            // For example, you can add a switch for on/off toggle:
            Consumer<RestTimerProvider>(
              builder: (context, restTimerProvider, child) {
                return Row(
                  children: [
                    const Text(
                      'Rest Timer',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Switch(
                      value: restTimerProvider.isRestTimerEnabled,
                      onChanged: (value) {
                        // Handle toggle switch changes here
                        if (value) {
                          restTimerProvider.startRestTimer(context);
                        } else {
                          restTimerProvider.stopRestTimer();
                        }
                        restTimerProvider.toggleRestTimer(value);
                      },
                    ),
                  ],
                );
              },
            ),
            // Add more settings components as needed
          ],
        ),
      ),
    );
  }
}
