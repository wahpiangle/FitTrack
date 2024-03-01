import 'package:flutter/material.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';

class UserProfileProvider extends ChangeNotifier {
  late String _profileImage;
  late String _username;

  UserProfileProvider() {
    _profileImage = '';
    _username = '';
    _loadProfileImage();
    _loadUsername();
  }

  String get profileImage => _profileImage;
  String get username => _username;

  Future<void> _loadProfileImage() async {
    _profileImage = await FirebaseUserService.getProfilePicture();
    notifyListeners();
  }

  Future<void> _loadUsername() async {
    _username = await FirebaseUserService.getUsername();
    notifyListeners();
  }

  void updateProfileImage() {
    _loadProfileImage();
    notifyListeners();
  }

  void updateUsername(String name) {
    _username = name;
    notifyListeners();
  }
}
