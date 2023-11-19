import 'package:flutter/material.dart';

class UserState {
  final bool isLoggedIn;

  UserState(this.isLoggedIn);
}

class UserStateProvider extends ChangeNotifier {
  UserState _userState = UserState(false);

  UserState get userState => _userState;

  void updateUserState(bool isLoggedIn) {
    _userState = UserState(isLoggedIn);
    notifyListeners();
  }
}
