import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';

class UserProfileProvider extends ChangeNotifier {
  String _profileImage = '';
  String _username = '';
  String _displayName = '';
  late FirebaseUser _user;

  UserProfileProvider() {
    _loadUserProfile();
  }

  String get profileImage => _profileImage;
  String get username => _username;
  String get displayName => _displayName;

  Future<void> _loadUserProfile() async {
    _user = await FirebaseUserService.getCurrentUser();
    _profileImage = _user.photoUrl;
    _username = _user.username;
    _displayName = _user.displayName;
    notifyListeners();
  }

  Future<void> updateProfileImage(String image) async {
    await FirebaseUserService.storeProfilePicture(image);
    await _loadUserProfile();
    notifyListeners();
  }

  Future<void> updateUsername(String username) async {
    await FirebaseUserService.updateUsername(username);
    await _loadUserProfile();
    notifyListeners();
  }

  Future<void> updateDisplayName(String name) async {
    _displayName = name;
    await FirebaseUserService.updateDisplayName(displayName);
    notifyListeners();
  }

  void reset() {
    _profileImage = '';
    _username = '';
    _displayName = '';
    notifyListeners();
  }

  void loadAll() {
    _loadUserProfile();
    notifyListeners();
  }
}
