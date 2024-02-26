import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/auth/edit_password.dart';
import 'package:group_project/pages/settings/components/logout_button.dart';
import 'package:group_project/pages/settings/components/profile_menu_item.dart';
import 'package:group_project/pages/settings/timer_details_settings.dart';
import 'package:provider/provider.dart';
import 'package:group_project/services/firebase/auth_service.dart';
import 'package:group_project/pages/auth/offline_edit.dart';
import 'dart:io';
import 'package:group_project/pages/workout/State/timer_sheet_manager.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String username = '';
  late String profileImage = '';
  User? currentUser = AuthService().getCurrentUser();
  late bool isSignInWithGoogle;

  @override
  void initState() {
    super.initState();
    isSignInWithGoogle =
        currentUser?.providerData.first.providerId == 'google.com';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleTimerActive(context); // Add this line to handle timer state
      _loadUserData();
    });
  }

  void _handleTimerActive(BuildContext context) {
    TimerProvider? timerProvider =
        Provider.of<TimerProvider>(context, listen: false);

    void handleTimerStateChanged() {
      if (timerProvider.isTimerRunning &&
          !TimerManager().isTimerActiveScreenOpen) {
        TimerManager().showTimerBottomSheet(context,
            []); // Pass an empty exercise list or provide relevant data
      } else if (!timerProvider.isTimerRunning &&
          TimerManager().isTimerActiveScreenOpen) {
        TimerManager().closeTimerBottomSheet(context);
      }
    }

    void Function()? listener;
    listener = () {
      if (mounted) {
        handleTimerStateChanged();
      } else {
        timerProvider.removeListener(listener!);
      }
    };

    timerProvider.addListener(listener);
  }

  void _loadUserData() {
    setState(() {
      username = currentUser?.displayName ?? '';
      profileImage = currentUser?.photoURL ?? '';
      // Provider.of<ProfileImageProvider>(context, listen: false)
      //     .updateProfileImage(profileImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: const Color(0xFF1A1A1A),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipOval(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: (profileImage.isEmpty ||
                                      profileImage ==
                                          'assets/icons/defaultimage.jpg')
                                  ? const AssetImage(
                                      'assets/icons/defaultimage.jpg')
                                  : FileImage(File(profileImage))
                                      as ImageProvider<Object>?,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                username,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                backgroundColor: AppColours.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfilePage(
                                          username: username,
                                          profileImage: profileImage)),
                                );
                              },
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 55),
                    ProfileMenuItem(
                      title: "Notifications",
                      icon: Icons.notifications,
                      onPressed: () {},
                    ),
                    ProfileMenuItem(
                      title: "Timer",
                      icon: Icons.timer,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TimerDetailsSettings(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      title: "Help Centre",
                      icon: Icons.info,
                      onPressed: () {},
                    ),
                    if (!isSignInWithGoogle)
                      ProfileMenuItem(
                        title: "Edit Password",
                        icon: Icons.key_outlined,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EditPassword(),
                            ),
                          );
                        },
                      ),
                    ProfileMenuItem(
                      title: "Terms and Conditions",
                      icon: Icons.gavel,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 40),
                    LogoutButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
