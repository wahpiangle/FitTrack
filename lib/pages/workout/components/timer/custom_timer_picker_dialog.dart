import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/workout/components/timer/components/about_rest_timer_dialog.dart';
import 'package:group_project/pages/workout/components/timer/components/time_picker.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';

class CustomTimerPickerDialog extends StatelessWidget {
  final CustomTimerProvider customTimerProvider;
  final void Function(BuildContext) showCustomTimerDetailsDialog;

  const CustomTimerPickerDialog({
    super.key,
    required this.customTimerProvider,
    required this.showCustomTimerDetailsDialog,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColours.primary,
      surfaceTintColor: Colors.transparent,
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                const Text(
                  'Rest Timer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.help, color: Colors.white),
                  onPressed: () {
                    showAboutRestTimerDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              height: MediaQuery.of(context).size.shortestSide * 0.7,
              width: MediaQuery.of(context).size.shortestSide * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.shortestSide * 0.35,
                ),
                border: Border.all(color: AppColours.secondary, width: 5),
              ),
              child: ClipOval(
                child: Container(
                  color: AppColours.secondary,
                  child: TimePicker(
                    customTimerProvider: customTimerProvider,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  customTimerProvider.resetCustomTimer(
                    customTimerProvider.customTimerMinutes * 60 +
                        customTimerProvider.customTimerSeconds,
                    context,
                  );
                  Navigator.of(context).pop();
                  showCustomTimerDetailsDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC1C1C1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'Start Rest Timer',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAboutRestTimerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AboutRestTimerDialog();
    },
  );
}
