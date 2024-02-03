import 'package:flutter/material.dart';

class UploadImageProvider with ChangeNotifier {
  bool _uploadError = false;
  bool _uploading = false;

  void toggleIsUploading(bool value) {
    _uploading = value;
    notifyListeners();
  }

  void toggleUploadError(bool value) {
    _uploadError = value;
    notifyListeners();
  }

  bool get uploading => _uploading;
  bool get uploadError => _uploadError;

  void test() {
    print(uploadError);
    print(uploading);
  }
}
