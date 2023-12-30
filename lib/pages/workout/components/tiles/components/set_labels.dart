import 'package:flutter/material.dart';

class SetLabels extends StatelessWidget {
  final void Function(int exerciseSetId)? setIsCompleted;
  const SetLabels({
    super.key,
    this.setIsCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 30,
          child: Text(
            "Set",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(
          flex: 1,
          child: Center(
            child: Text(
              "Weight",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(
          flex: 1,
          child: Center(
            child: Text(
              "Reps",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        setIsCompleted != null ? const SizedBox(width: 40) : Container(),
      ],
    );
  }
}
