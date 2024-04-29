import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/services/firebase/auth_service.dart';

class EmailPasswordLogin extends StatefulWidget {
  const EmailPasswordLogin({super.key});

  @override
  State<EmailPasswordLogin> createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0.0,
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF333333)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
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
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF333333)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                    validator: (val) => val!.length < 6
                        ? 'Enter a password 6 characters long'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }),
                const SizedBox(height: 40.0),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          );
                          await _auth.signInWithEmailAndPassword(
                              email, password);
                          Future.microtask(() => Navigator.of(context).pop());
                          Future.microtask(() => Navigator.pop(context));
                          errorMessage = '';
                        } on FirebaseAuthException catch (error) {
                          if (error.code == "invalid-email") {
                            Future.microtask(() => Navigator.of(context).pop());
                            errorMessage = 'The email format is invalid.';
                          } else {
                            Future.microtask(() => Navigator.of(context).pop());
                            errorMessage =
                                'The email or password you\'ve entered is incorrect.';
                          }
                        }
                        setState(() {});
                      }
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(290, 40)),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffe1f0cf)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    child: const Text('Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                          fontSize: 16,
                        )),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: TextButton(
                    child: const Text('Don\'t have an account? Create one now',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("register");
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    child: const Text('Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    onPressed: () {
                      Navigator.of(context).pushNamed("forgot-password");
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
                Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
