import 'package:flutter/material.dart';
import 'package:group_project/constants/upload_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadImageProvider with ChangeNotifier {
  Future<void> setUploadError(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(UploadEnums.isUploadingError, value);
  }

  Future<bool> getUploadError() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UploadEnums.isUploadingError) ?? false;
  }

  void test() {}
}
