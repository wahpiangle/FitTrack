import 'package:flutter/material.dart';

class SetLabels extends StatelessWidget {
  final void Function(int exerciseSetId)? setIsCompleted;
  final String categoryName;
  const SetLabels({
    this.setIsCompleted,
    required this.categoryName,
    super.key,
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
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              categoryName == "Duration"
                  ? "Duration"
                  : categoryName == "Reps Only"
                      ? "Reps"
                      : categoryName == "Assisted Bodyweight"
                          ? "-kg"
                          : "Weight (kg)",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 10),
        categoryName != "Duration" && categoryName != "Reps Only"
            ? const Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "Reps",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : const SizedBox.shrink(),
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
