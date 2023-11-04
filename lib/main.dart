import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_project/pages/auth/email_password_login.dart';
import 'package:group_project/pages/auth/register_screen.dart';
import 'package:group_project/pages/auth_wrapper.dart';
import 'package:group_project/services/auth_service.dart';
import 'package:group_project/services/objectbox_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

late ObjectBox objectBox;

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
    return StreamProvider.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        home: const Wrapper(),
        routes: {
          '/auth': (context) => const Wrapper(),
          "login" : (context) => const EmailPasswordLogin(),
          "register": (context) => const RegisterScreen(),
        },
        theme: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1A1A1A), // Set the background color
            selectedItemColor:
                Color(0xFFE1F0CF), // Set the color of selected item
            unselectedItemColor:
                Colors.grey, // Set the color of unselected items
          ),
        ),
      ),
    );
  }
}
