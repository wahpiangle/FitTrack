import 'package:flutter/material.dart';

class FilterLabel extends StatelessWidget {
  final String text;
  final bool isFilterSelected;
  final Function() onTap;

  const FilterLabel({
    super.key,
    required this.text,
    required this.isFilterSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isFilterSelected) {
      return FittedBox(
        fit: BoxFit.fitWidth,
        child: SizedBox(
          height: 35,
          child: TextButton.icon(
            icon: const Icon(
              Icons.close,
              color: Color(0xFF333333),
              size: 30,
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: const Color(0xFFE1F0CF),
            ),
            label: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
            onPressed: () {
              onTap();
            },
          ),
        ),
      );
    }
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xFFE1F0CF),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
