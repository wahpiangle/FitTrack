import 'package:flutter/services.dart';

class AppleWatchMethods {
  static const channel = MethodChannel('com.quanming.fittrack_channel');
  static const String flutterToWatch = "flutterToWatch";
  static const String sendTemplatesToWatch = "sendTemplatesToWatch";
}