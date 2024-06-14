import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';

class StatItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isFriend;
  final String userId;
  final VoidCallback onFriendRemoved;

  const StatItem({
    super.key,
    required this.label,
    required this.count,
    this.isFriend = false,
    required this.userId,
    required this.onFriendRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColours.secondaryLight,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
