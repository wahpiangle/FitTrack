import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_template.dart';
import 'package:group_project/pages/workout/workout_templates/create_template_page.dart';

class WorkoutTemplates extends StatefulWidget {
  const WorkoutTemplates({super.key});

  @override
  State<WorkoutTemplates> createState() => _WorkoutTemplatesState();
}

class _WorkoutTemplatesState extends State<WorkoutTemplates> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Workout Templates',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTemplatePage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  AppColours.secondary,
                ),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                  horizontal: 10,
                )),
              ),
              label: const Text(
                'Template',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        StreamBuilder<List<WorkoutTemplate>>(
          stream: objectBox.workoutTemplateService.watchWorkoutTemplates(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final workoutTemplate = snapshot.data![index];
                  // TODO
                  return ListTile(
                    title: Text(workoutTemplate.title),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
