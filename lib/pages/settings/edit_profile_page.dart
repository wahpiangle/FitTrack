import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/layout/top_nav_bar.dart';
import 'package:group_project/pages/settings/components/image_picker_options.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  final String profileImage;
  final void Function(String name, String image) setUserInfo;

  const EditProfilePage({
    super.key,
    required this.username,
    required this.profileImage,
    required this.setUserInfo,
  });

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late String profileImage;
  final ImagePicker _picker = ImagePicker();
  final int maxUsernameLength = 15;
  bool showWarning = false;
  bool isFileImage = false;

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
        isFileImage = true;
        profileImage = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(
        pageIndex: 0,
        title: 'Edit Profile',
        user: null,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColours.primary,
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
                        onTap: () => {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ImagePickerOptions(
                                pickImage: _pickImage,
                              );
                            },
                          )
                        },
                        child: (profileImage == '')
                            ? const CircleAvatar(
                                radius: 120,
                                backgroundImage:
                                    AssetImage('assets/icons/defaultimage.jpg'),
                              )
                            : isFileImage
                                ? CircleAvatar(
                                    radius: 120,
                                    backgroundImage:
                                        FileImage(File(profileImage)),
                                  )
                                : SizedBox(
                                    width: 240,
                                    height: 240,
                                    child: CachedNetworkImage(
                                      imageUrl: profileImage,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 120,
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        radius: 120,
                                        backgroundImage: AssetImage(
                                            'assets/icons/defaultimage.jpg'),
                                      ),
                                    ),
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
                    labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
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
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text('Cancel',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (usernameController.text.length >
                                  maxUsernameLength) {
                                setState(() {
                                  showWarning = true;
                                });
                              } else {
                                widget.setUserInfo(
                                    usernameController.text, profileImage);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFFE1F0CF), // Change button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Make it round
                              ),
                            ),
                            child: const Text('Save',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
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
}
