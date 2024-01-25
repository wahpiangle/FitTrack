import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/auth/edit_password.dart';
import 'package:group_project/pages/auth/settings_signup.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'package:group_project/pages/settings/timer_details_settings.dart';
import 'package:provider/provider.dart';
import 'package:group_project/services/firebase/auth_service.dart';
import 'package:group_project/services/user_state.dart';
import 'package:group_project/pages/auth/offline_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:group_project/pages/workout/State/timer_sheet_manager.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _prefs;
  late String username = '';
  late String profileImage = '';
  late bool isAnonymous = false;
  late bool isSignInWithGoogle = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      _handleTimerActive(context); // Add this line to handle timer state
    });
  }

  void _handleTimerActive(BuildContext context) {
    TimerProvider? timerProvider =
    Provider.of<TimerProvider>(context, listen: false);

    void handleTimerStateChanged() {
      if (timerProvider.isTimerRunning &&
          !TimerManager().isTimerActiveScreenOpen) {
        TimerManager().showTimerBottomSheet(context, []); // Pass an empty exercise list or provide relevant data
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


  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    User? currentUser = AuthService().getCurrentUser();
    bool fetchedIsAnonymous =
        AuthService().getCurrentUser()?.isAnonymous ?? false;

    setState(() {
      isAnonymous = fetchedIsAnonymous;
      if (!isAnonymous) {
        _loadFirebaseUserData();
      } else {
        _loadAnonymousUserData();
      }
    });

    setState(() {
      isSignInWithGoogle =
          currentUser?.providerData.first.providerId == 'google.com';
      if (!isSignInWithGoogle) {
        if (currentUser == null || currentUser.isAnonymous) {
          _loadAnonymousUserData();
        } else {
          _loadFirebaseUserData();
        }
      }
    });
  }

  _loadFirebaseUserData() async {
    User? currentUser = AuthService().getCurrentUser();

    if (currentUser != null) {
      if (currentUser.displayName == null || currentUser.displayName!.isEmpty) {
        // New user using email/Gmail login method
        await _generateAndUploadRandomUsername();
      } else {
        // Existing user, load the data
        setState(() {
          username = currentUser.displayName ?? '';
          profileImage = currentUser.photoURL ?? '';
          Provider.of<ProfileImageProvider>(context, listen: false)
              .updateProfileImage(profileImage);
        });
      }
    }
  }

  _generateAndUploadRandomUsername() async {
    String newUsername = generateUsername();
    User? currentUser = AuthService().getCurrentUser();

    if (currentUser != null) {
      // Update Firebase user profile with the random username
      await AuthService().updateUserProfile(displayName: newUsername);

      setState(() {
        username = newUsername;
      });
    }
  }

  _loadAnonymousUserData() {
    username = _prefs.getString('username') ?? generateUsername();
    profileImage =
        _prefs.getString('profile_image') ?? 'assets/icons/defaultimage.jpg';
  }

  String generateUsername() {
    String username = 'User_${DateTime.now().millisecondsSinceEpoch}';

    // Limit the username to 15 characters
    if (username.length > 15) {
      username = username.substring(0, 15);
    }

    return username;
  }

  _saveUserData() async {
    if (isAnonymous) {
      await _prefs.setString('username', username);
      await _prefs.setString('profile_image', profileImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserStateProvider userStateProvider =
        Provider.of<UserStateProvider>(context);

    bool isLoggedIn = userStateProvider.userState.isLoggedIn;

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
                              fontSize: 24,
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
                            child: (profileImage.isEmpty ||
                                    profileImage ==
                                        'assets/icons/defaultimage.jpg')
                                ? const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(
                                        'assets/icons/defaultimage.jpg'),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        FileImage(File(profileImage)),
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
                                // user?.displayName ?? 'User',
                                username,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE1F0CF),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Check if the user is logged in or not
                                  if (isLoggedIn) {
                                    _editProfile(context);
                                  } else {
                                    _editProfile(context);
                                  }
                                },
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: Color(0xFF1A1A1A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    ProfileMenuItem(
                      title: "Notifications",
                      icon: Icons.notifications,
                      onPressed: () {

                      },
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
                      onPressed: () {

                      },
                    ),
                    if ((isAnonymous))
                      ProfileMenuItem(
                        title: "Sign Up / Log In",
                        icon: Icons.person,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsSignup(),
                            ),
                          );
                        },
                      )
                    else if (!isSignInWithGoogle)
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
                      onPressed: () {

                      },
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

      // Nav Bar
    );
  }

  void updateProfileImage(String newProfileImage) {
    setState(() {
      profileImage = newProfileImage;
      if (isAnonymous) {
        _saveUserData(); // Save updated profile image for anonymous users
      } else {

      }
    });
  }

  void _editProfile(BuildContext context) async {
    Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditProfilePage(username: username, profileImage: profileImage)),
    );

    if (result != null &&
        result.containsKey('username') &&
        result['username'] != null) {
      setState(() {
        username = result['username']!;
        if (result.containsKey('profileImage')) {
          profileImage = result['profileImage'];
          // Update Firebase user profile for authenticated users
          if (!isAnonymous) {
            AuthService().updateUserProfile(
                displayName: username, photoURL: profileImage);
          }
          _saveUserData();
        }
      });
    }
  }
}

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class LogoutButton extends StatelessWidget {
  final AuthService authService = AuthService();
  LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          authService.signOut();
          Future.microtask(
                  () => Navigator.of(context).popAndPushNamed('/auth'));
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          backgroundColor: Colors.transparent,
        ),
        child: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
