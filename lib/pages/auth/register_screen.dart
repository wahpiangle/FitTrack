import 'package:flutter/material.dart';
import 'package:group_project/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      // const Color(0xFF1A1A1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        centerTitle: true,
        elevation: 0.0,
        title: const Text('Sign up'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/background.png'),
          ),
        ),

        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  decoration: const InputDecoration(
                    hintText: 'you@example.com',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink, width: 2.0)),
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
                  )
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                  decoration: const InputDecoration(
                    hintText: '******',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink, width: 2.0)),
                  ),
                  obscureText: true,
                  validator: (val) =>
                      val!.length < 6 ? 'Enter a password 6 chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  }),
              const SizedBox(height: 40.0),

              FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _auth.registerWithEmailAndPassword(
                            email, password);
                        if (result == null) {
                          setState(() => error = 'please supply a valid email');
                        }
                        if (result != null) {
                          Future.microtask(() => Navigator.pop(context));
                        }
                      }
                    },

                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(290, 40)),
                    backgroundColor: MaterialStateProperty.all(
                        const Color(0xFFE1F0CF)),
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: const Text('Register',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                        fontSize: 16,
                      )
                  ),
                ),
              ),

              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
