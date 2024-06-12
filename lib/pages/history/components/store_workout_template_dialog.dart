import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';

class StoreWorkoutTemplateDialog extends StatefulWidget {
  final int workoutSessionId;
  const StoreWorkoutTemplateDialog({super.key, required this.workoutSessionId});

  @override
  State<StoreWorkoutTemplateDialog> createState() =>
      _StoreWorkoutTemplateDialogState();
}

class _StoreWorkoutTemplateDialogState
    extends State<StoreWorkoutTemplateDialog> {
  String _workoutTemplateTitle = '';

  @override
  void initState() {
    _workoutTemplateTitle = objectBox.workoutSessionService
        .getWorkoutSession(widget.workoutSessionId)!
        .title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      surfaceTintColor: Colors.transparent,
      title: const Center(
        child: Text(
          'Save as Template',
          style: TextStyle(
            color: Color(
              0xFFE1F0CF,
            ),
            fontSize: 16,
          ),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose a name for the template',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              initialValue: _workoutTemplateTitle,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: 'Template name',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.black38,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColours.secondary,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _workoutTemplateTitle = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.black38,
                    ),
                    overlayColor: WidgetStateProperty.all(
                      Colors.grey[900],
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    objectBox.workoutTemplateService
                        .createWorkoutTemplateFromWorkoutSession(
                      objectBox.workoutSessionService
                          .getWorkoutSession(widget.workoutSessionId)!,
                      _workoutTemplateTitle,
                    );
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColours.secondary,
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
