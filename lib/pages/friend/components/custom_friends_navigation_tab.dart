import 'package:flutter/material.dart';

class CustomFriendsNavigationTab extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final int friendRequests;

  const CustomFriendsNavigationTab(
      {super.key,
      required this.text,
      required this.color,
      required this.onTap,
      this.friendRequests = 0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: SizedBox(
        height: 40,
        width: 100,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: color,
                ),
              ),
              friendRequests > 0
                  ? Container(
                      height: 20,
                      width: 20,
                      margin: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          friendRequests.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
