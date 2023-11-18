import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EditProfile extends StatefulWidget {
  final User? user;

  const EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController displayNameController;

  @override
  void initState() {
    super.initState();
    displayNameController = TextEditingController(text: widget.user?.displayName ?? '');
  }

  Future<void> _updateProfile() async {
    try {
      // Update profile for authenticated users
      if (widget.user != null) {
        await widget.user!.updateDisplayName(displayNameController.text);
        // Update other user info if needed
      } else {
        // For non-authenticated users, you can save the profile locally or perform other actions
        // This is a placeholder action and should be replaced with your desired functionality
        print('Profile Updated Locally: Display Name - ${displayNameController.text}');
      }

      // Profile updated successfully, maybe show a success message or navigate back
    } catch (e) {
      // Handle errors or display an error message
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: displayNameController,
              decoration: InputDecoration(labelText: 'Display Name'),
            ),
            // Other input fields for updating profile

            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
