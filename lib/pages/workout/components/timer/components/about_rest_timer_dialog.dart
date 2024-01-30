import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';

class AboutRestTimerDialog extends StatelessWidget {
  const AboutRestTimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColours.primaryBright,
      surfaceTintColor: Colors.transparent,
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
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Manually set a Custom Rest Timer at any time.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Auto Rest Timers can be set up to start when a set is completed.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14),
          Text(
            'To set the Auto Rest Timer duration, navigate to Settings >> Timer >> Rest Duration.',
            style: TextStyle(
              color: Colors.grey,
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
  }
}
