import 'package:flutter/material.dart';

class EmailPasswordLogin extends StatefulWidget {
  const EmailPasswordLogin({super.key});

  @override
  State<EmailPasswordLogin> createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Sign in to Fit Connect'),
        
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                onChanged: (val) {
                  setState(() => email = val );

                }
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val );

                }
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  child: const Text(
                      'Sign in',
                    style: TextStyle(color: Colors.white),

                  ),
                  onPressed: () async {
                    print(email);
                    print(password);

                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
