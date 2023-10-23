import 'package:flutter/material.dart';

class NewWorkout extends StatelessWidget {
  final String imagePath;
  final String workoutText;


  NewWorkout({
    required this.imagePath,
    required this.workoutText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      width: 150,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF333333),
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
                SizedBox(width: 70),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcATop,
                  ),
                  child: Transform.translate(
                    offset: Offset(0, -8), // (move up)
                    child: Image.asset(
                      'assets/info.png',
                      width: 20,
                      height: 10,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Text(
                workoutText,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFFE1F0CF), width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ), // End of shape configuration
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Adjust the values for width and height
                ),
              ),
              child: Text('Start Workout'),
            )

          ],
        ),
      ),
    );
  }
}
