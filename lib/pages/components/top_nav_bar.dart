import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:group_project/pages/settings_screen.dart';

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

    String profileImage = Provider.of<ProfileImageProvider>(context).profileImage;

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SizedBox(
                width: 40,
                height: 40,
                child: ClipOval(
                  child:  (profileImage.isEmpty || profileImage == 'assets/icons/defaultimage.jpg')
                      ? const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/icons/defaultimage.jpg'),
                  )
                      : CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(File(profileImage)),
                  ),
                ),
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


class ProfileImageProvider extends ChangeNotifier {
  late String _profileImage;

  ProfileImageProvider() {
    _profileImage = ''; // Fetch the stored profile image on app start
    _loadProfileImage();
  }

  String get profileImage => _profileImage;

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _profileImage = prefs.getString('profile_image') ?? ''; // Load the stored image path
    notifyListeners();
  }

  Future<void> updateProfileImage(String newImage) async {
    _profileImage = newImage;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', newImage); // Save the updated image path
  }
}
