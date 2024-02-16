import 'package:permission_handler/permission_handler.dart';

// ...

Future<void> requestContactsPermission() async {
  var status = await Permission.contacts.status;
  if (!status.isGranted) {
    await Permission.contacts.request();
  }
}
