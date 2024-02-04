import 'package:flutter/material.dart';
import 'package:group_project/constants/upload_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadImageProvider with ChangeNotifier {
  bool _uploading = false;
  bool _uploadError = false;

  void setIsUploading(bool value) {
    _uploading = value;
    notifyListeners();
    setSharedPreferences();
  }

  void setUploadError(bool value) {
    _uploadError = value;
    notifyListeners();
    setSharedPreferences();
  }

  void getSharedPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      _uploading = prefs.getBool(UploadEnums.isUploading) ?? false;
      _uploadError = prefs.getBool(UploadEnums.isUploadingError) ?? false;
      notifyListeners();
    });
  }

  Future<void> setSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(UploadEnums.isUploading, _uploading);
    prefs.setBool(UploadEnums.isUploadingError, _uploadError);
  }

  bool get uploading => _uploading;
  bool get uploadError => _uploadError;
}
