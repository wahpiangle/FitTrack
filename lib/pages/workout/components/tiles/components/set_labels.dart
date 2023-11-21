import 'package:flutter/material.dart';

class SetLabels extends StatelessWidget {
  const SetLabels({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: Center(
            child: Text(
              "Set",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              "Weight",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              "Reps",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        SizedBox(width: 40)
      ],
    );
  }
}
