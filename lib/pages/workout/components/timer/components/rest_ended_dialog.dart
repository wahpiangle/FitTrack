import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';

class RestEndedDialog extends StatelessWidget {
  const RestEndedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColours.primary,
      surfaceTintColor: Colors.transparent,
      title: const Center(
        child: Text(
          'Rest Time Ended',
          style: TextStyle(color: Colors.white, fontSize: 20,),
        ),
      ),
      content: Text(
        'Your rest time has ended !\n⏰ 💪',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                const Color(0xFF333333),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
