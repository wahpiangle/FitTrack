import 'package:flutter/material.dart';
import 'package:group_project/services/firebase/auth_service.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';

class UserProfileProvider extends ChangeNotifier {
  String _profileImage = '';
  String _username = '';
  String _displayName = '';

  UserProfileProvider() {
    _loadProfileImage();
    _loadUsername();
    _loadDisplayName();
  }

  String get profileImage => _profileImage;
  String get username => _username;
  String get displayName => _displayName;

  Future<void> _loadProfileImage() async {
    _profileImage = await FirebaseUserService.getProfilePicture();
    notifyListeners();
  }

  Future<void> _loadUsername() async {
    _username = await FirebaseUserService.getUsername();
    notifyListeners();
  }

  Future<void> _loadDisplayName() async {
    _displayName = AuthService().getCurrentUser()?.displayName ?? '';
    notifyListeners();
  }

  Future<void> updateProfileImage(String image) async {
    await FirebaseUserService.storeProfilePicture(image);
    _loadProfileImage();
    notifyListeners();
  }

  Future<void> updateUsername(String username) async {
    await FirebaseUserService.updateUsername(username);
    _loadUsername();
    notifyListeners();
  }

  Future<void> updateDisplayName(String name) async {
    _displayName = name;
    await FirebaseUserService.updateDisplayName(displayName);
    notifyListeners();
  }
}
