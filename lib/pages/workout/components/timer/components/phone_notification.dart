import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Create a notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id_timer_2',
      'channel_name_timer_2',
      importance: Importance.max,
      playSound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Check and request notification permissions
    await _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> showPhoneNotification(String title, String message) async {
    // Check if notification permission is granted
    final status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      // Handle the case where the user hasn't granted notification permission
      // You may show an explanation to the user or navigate them to the settings
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id_timer_2',
      'channel_name_timer_2',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
    );
  }
}
