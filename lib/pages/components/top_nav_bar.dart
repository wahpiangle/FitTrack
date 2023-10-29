import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final User? user;
  final String title;
  final bool showBackButton;

  const TopNavBar({
    super.key,
    required this.title,
    required this.user,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1A1A1A),
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Will lead to Search friends page
              },
            ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: user?.photoURL == null
                  ? Image.asset('assets/icons/defaultimage.jpg')
                  : CachedNetworkImage(
                      imageUrl: user!.photoURL!,
                      placeholder: (context, url) =>
                          Image.asset('assets/icons/defaultimage.jpg'),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/icons/defaultimage.jpg'),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
