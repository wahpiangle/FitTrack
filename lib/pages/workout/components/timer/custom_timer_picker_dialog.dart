import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/workout/components/timer/rest_time_picker.dart';
import 'package:group_project/pages/workout/components/timer/resttimer_details_dialog.dart';
import 'custom_timer_provider.dart';

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
      backgroundColor: AppColours.primaryBright,
      content: SizedBox(
        height: MediaQuery.of(context).size.height*0.56,
        width:  MediaQuery.of(context).size.width,
        child: Column(
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
              height: MediaQuery.of(context).size.height*0.33,
              width: MediaQuery.of(context).size.width*0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                border: Border.all(color: AppColours.secondary, width: 5),
              ),
              child: ClipOval(
                child: Container(
                  color: AppColours.secondary,
                  child: CustomTimerPicker(
                    customTimerProvider: customTimerProvider,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              height: MediaQuery.of(context).size.height*0.055,
              width: MediaQuery.of(context).size.width*0.73,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                // Rounded corners
              ),
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
                  backgroundColor: Color(0xFFC1C1C1),
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
