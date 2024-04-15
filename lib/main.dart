import 'package:camera/camera.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_project/pages/auth/email_password_login.dart';
import 'package:group_project/pages/auth/forgot_password.dart';
import 'package:group_project/pages/auth/register_screen.dart';
import 'package:group_project/pages/auth_wrapper.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/complete_workout/congratulation_screen.dart';
import 'package:group_project/pages/complete_workout/capture_image/post_workout_prompt.dart';
import 'package:group_project/pages/home/scroll_provider.dart';
import 'package:group_project/pages/layout/app_layout.dart';
import 'package:group_project/pages/history/history_screen.dart';
import 'package:group_project/pages/layout/user_profile_provider.dart';
import 'package:group_project/pages/workout/components/timer/components/phone_notification.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';
import 'package:group_project/services/firebase/auth_service.dart';
import 'package:group_project/services/objectbox_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';

late ObjectBox objectBox;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late PhoneNotification notificationManager;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  objectBox = await ObjectBox.create();

  await FirebaseAppCheck.instance.activate(
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.debug,
  );

  notificationManager = PhoneNotification();
  await notificationManager.initializeNotifications();
  final cameras = await availableCameras();

  runApp(MyApp(
    cameras: cameras,
  ));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({
    super.key,
    required this.cameras,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (context) => RestTimerProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => CustomTimerProvider()),
        ChangeNotifierProvider(create: (context) => UploadImageProvider()),
        ChangeNotifierProvider(create: (context) => ScrollProvider()),
        StreamProvider.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'FitTrack',
        home: const Wrapper(),
        routes: {
          '/auth': (context) => const Wrapper(),
          "login": (context) => const EmailPasswordLogin(),
          "register": (context) => const RegisterScreen(),
          "app_layout": (context) => const AppLayout(),
          "congratulation_screen": (context) => const CongratulationScreen(),
          "history_screen": (context) => const HistoryScreen(
                exerciseData: [],
              ),
          "post_workout_prompt": (context) => PostWorkoutPrompt(
                cameras: cameras,
              ),
          "forgot-password": (context) => const ForgotPassword(),
        },
        theme: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1A1A1A),
            selectedItemColor: Color(0xFFE1F0CF),
            unselectedItemColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}




