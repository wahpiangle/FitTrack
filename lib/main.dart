import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_project/pages/history/congratulation_screen.dart';
import 'package:group_project/pages/auth/email_password_login.dart';
import 'package:group_project/pages/auth/register_screen.dart';
import 'package:group_project/pages/auth/settings_login.dart';
import 'package:group_project/pages/auth/settings_signup.dart';
import 'package:group_project/pages/auth/auth_wrapper.dart';
import 'package:group_project/pages/components/app_layout.dart';
import 'package:group_project/pages/history/history_screen.dart';
import 'package:group_project/pages/workout/components/timer/custom_timer_provider.dart';
import 'package:group_project/services/auth_service.dart';
import 'package:group_project/services/objectbox_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'package:group_project/services/user_state.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';

late ObjectBox objectBox;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  objectBox = await ObjectBox.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (context) => RestTimerProvider()),
        ChangeNotifierProvider(create: (context) => UserStateProvider()),
        ChangeNotifierProvider(create: (context) => ProfileImageProvider()),
        ChangeNotifierProvider(create: (context) => CustomTimerProvider()),
        StreamProvider.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        home: const AuthWrapper(),
        routes: {
          '/auth': (context) => const AuthWrapper(),
          "login": (context) => const EmailPasswordLogin(),
          "register": (context) => const RegisterScreen(),
          "settings_login": (context) => const SettingsLogin(),
          "settings_signup": (context) => const SettingsSignup(),
          "app_layout": (context) => const AppLayout(),
          "congratulation_screen": (context) => const CongratulationScreen(),
          "history_screen": (context) => const HistoryScreen(),
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
