import 'package:flutter/material.dart';

class SetLabelsWeighted extends StatelessWidget {
  final void Function(int exerciseSetId)? setIsCompleted;
  const SetLabelsWeighted({
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
        const SizedBox(width: 10),
        const Expanded(
          flex: 1,
          child: Text(
            "Previous",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          flex: 1,
          child: Center(
            child: Text(
              "+kg",
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
        SizedBox(
          width: 40,
          child: Icon(
            setIsCompleted != null ? Icons.check : Icons.lock_outline,
            size: 20,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
