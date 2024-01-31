import 'package:flutter/material.dart';
import 'package:group_project/models/post.dart';

class UploadImageProvider with ChangeNotifier {
  bool _uploadError = false;
  bool _uploading = false;
  late Post _post;

  void toggleIsUploading(bool value) {
    _uploading = value;
    notifyListeners();
  }

  void toggleUploadError(bool value) {
    _uploadError = value;
    notifyListeners();
  }

  void setPost(Post post) {
    _post = post;
    notifyListeners();
  }

  void test() {
    print(_uploading);
    print(_uploadError);
    print(_post);
  }

  bool get uploading => _uploading;
  bool get uploadError => _uploadError;
  Post get post => _post;
}
