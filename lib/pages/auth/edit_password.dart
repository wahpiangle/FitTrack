import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {

  final _formKey = GlobalKey<FormState>();
  var newPassword = "";
  final newPasswordController = TextEditingController();
  String outputMessage = "";


  @override
  void dispose() {
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async{
    try{
     await currentUser!.updatePassword(newPassword);
    }catch(error){
      rethrow;
    }
  }

  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0.0,
        title: const Text('Edit Password'),
        centerTitle: true,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Enter your new password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: '******',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey,),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.white,),
                  ),
                ),
                controller: newPasswordController,
                validator: (val) =>
                val!.length < 6 ? 'Please enter a password 6 characters long' : null,
                ),
              const SizedBox(height: 30.0),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()){
                              setState(() {
                                newPassword = newPasswordController.text;
                              });
                              changePassword();
                              outputMessage ="You have successfully changed your password.";
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE1F0CF), // Change button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Make it round
                            ),
                          ),
                          child: const Text('Save Changes', style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
                        ),
                      ),

                    ],

                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  outputMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
      );
  }
}
