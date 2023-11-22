import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/services/auth_service.dart';

class SettingsSignup extends StatefulWidget {
  const SettingsSignup({super.key});

  @override
  State<SettingsSignup> createState() => _SettingsSignupState();
}

class _SettingsSignupState extends State<SettingsSignup> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      // const Color(0xFF1A1A1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        centerTitle: true,
        elevation: 0.0,
        title: const Text('Register'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10.0),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'you@example.com',
                    hintStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Color(0xFF333333)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (val) =>
                  val!.isEmpty ? 'Enter an invalid email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  }),
              const SizedBox(height: 30.0),
              const Text('Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10.0),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '******',
                    hintStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Color(0xFF333333)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (val) =>
                  val!.length < 6 ? 'Enter a password 6 characters long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  }),
              const SizedBox(height: 40.0),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Future.microtask(
                                    () => Navigator.of(context).popAndPushNamed('settings'));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Change button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Make it round
                            ),
                          ),
                          child: const Text('Cancel',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 20), // Add space between the buttons

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await _auth.registerWithEmailAndPassword(email, password);
                                Future.microtask(
                                        () => Navigator.of(context).popAndPushNamed('workout'));
                                errorMessage= '';
                              } on FirebaseAuthException catch (error) {
                                if (error.code == "invalid-email"){
                                  errorMessage = 'The email format is invalid.';
                                } else {
                                  errorMessage = 'The email is already taken by another account.';
                                }
                              }
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE1F0CF), // Change button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Make it round
                            ),
                          ),
                          child: const Text('Register', style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Center(
                child: TextButton(
                  child: const Text('Already a member? Login',
                      style: TextStyle(
                        color: Colors.white,
                      )
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("settings_login");
                  },
                ),
              ),
              const SizedBox(height: 12.0),
              Center(
                child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color:Colors.red,
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
