import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageProvider extends ChangeNotifier {
  late String _profileImage;

  ProfileImageProvider() {
    _profileImage = ''; // Fetch the stored profile image on app start
    _loadProfileImage();
  }

  String get profileImage => _profileImage;

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _profileImage =
        prefs.getString('profile_image') ?? ''; // Load the stored image path
    notifyListeners();
  }

  Future<void> updateProfileImage(String newImage) async {
    _profileImage = newImage;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'profile_image', newImage); // Save the updated image path
  }
}
