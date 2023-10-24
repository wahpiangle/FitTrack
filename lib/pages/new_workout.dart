import 'package:flutter/material.dart';

//Dart file for Templates for Workout
class NewWorkout extends StatelessWidget {
  final String imagePath;
  final String workoutText;


  const NewWorkout({super.key,
    required this.imagePath,
    required this.workoutText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      width:  150,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                    imagePath,
                  width: 40,
                  height: 30,
                ),
                const SizedBox(width: 70),
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcATop,
                  ),
                  child: Transform.translate(
                    offset: const Offset(0, -8), // (move up)
                    child: Opacity(
                      opacity: 0.7,
                      child: Image.asset(
                        'assets/info.png',
                        width: 18,
                        height: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Text(
                workoutText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFFE1F0CF), width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ), // End of shape configuration
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Adjust the values for width and height
                ),
              ),
              child: const Text('Start Workout'),
            )

          ],
        ),
      ),
    );
  }
}
