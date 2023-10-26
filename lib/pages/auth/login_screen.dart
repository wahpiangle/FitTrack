import 'package:flutter/material.dart';
import 'package:group_project/pages/auth/email_password_login.dart';
import 'package:group_project/pages/auth/register_screen.dart';
import 'package:magic_text/magic_text.dart';
import 'package:group_project/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/background.png'),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fitness\nUnleashed,',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 120),
                child: MagicText(
                  "Socially\nEnhanced",
                  breakWordCharacter: "-",
                  minFontSize: 24,
                  maxFontSize: 40,
                  smartSizeMode: true,
                  asyncMode: true,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  label: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await _auth.signInWithGoogle();
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    }
                  },
                  icon: Image.asset(
                    'assets/google.png',
                    height: 30,
                    width: 30,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffe1f0cf)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff1a1a1a)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          side: MaterialStateProperty.all(
                            const BorderSide(color: Color(0xffc1c1c1)),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EmailPasswordLogin(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff1a1a1a)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          side: MaterialStateProperty.all(
                            const BorderSide(color: Color(0xffc1c1c1)),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'By continuing you agree to the Terms & Conditions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
