import 'package:flutter/material.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class EditProfilePage extends StatefulWidget{

  final String username;
  final String profileImage;

  const EditProfilePage({super.key, required this.username, required this.profileImage});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late String profileImage;
  final ImagePicker _picker = ImagePicker();
  final int maxUsernameLength = 15;
  bool showWarning = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    profileImage = widget.profileImage;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        profileImage = pickedFile.path; // Save image path
      });
      Provider.of<ProfileImageProvider>(context, listen: false).updateProfileImage(profileImage);
    }
  }



  @override
  Widget build(BuildContext context) {

    final profileImageProvider = Provider.of<ProfileImageProvider>(context);

    return Scaffold(
      appBar: AppBar(
         backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
      child:Container(
        color: const Color(0xFF1A1A1A), // Change the background color to black
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Your border color
                        width: 3,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => _showPickImageOptions(context),
                      child: (profileImage.isEmpty || profileImage == 'assets/icons/defaultimage.jpg')
                          ? const CircleAvatar(
                        radius: 120,
                        backgroundImage: AssetImage('assets/icons/defaultimage.jpg'),
                      )
                          : CircleAvatar(
                        radius: 120,
                        backgroundImage: FileImage(File(profileImage)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter new username',
                  labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: showWarning ? Colors.red : Colors.white,
                    ),
                  ),
                ),
                maxLength: maxUsernameLength,
                onChanged: (value) {
                  setState(() {
                    showWarning = value.length >= maxUsernameLength;
                  });
                },
              ),
              if (showWarning)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Username exceeds the character limit',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
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
                            if (usernameController.text.length > maxUsernameLength) {
                              setState(() {
                                showWarning = true;
                              });
                            } else {
                              // Process the username here
                              Navigator.pop(
                                context,
                                {
                                  'username': usernameController.text,
                                  'profileImage': profileImage,
                                },
                              );
                              profileImageProvider.updateProfileImage(profileImage);
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

              const SizedBox(height: 250),
            ],
          ),
        ),
      ),
      ),
    );
  }

  void _showPickImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 220,
          padding: const EdgeInsets.all(20),
          color: Colors.grey[850], // Set the background color to grey
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Choose an option', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20)),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text('Pick from Gallery', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Take a Picture', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          _pickImage(ImageSource.camera);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}