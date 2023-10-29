import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'package:provider/provider.dart';
import 'components/bottom_nav_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:group_project/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      appBar: TopNavBar(
        title: 'Settings',
        user: user,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1A1A1A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add a Column for the Profile heading
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 25,
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
                        width: 110,
                        height: 110,
                        child: ClipOval(
                          child: user?.photoURL == null
                              ? Image.asset('assets/icons/defaultimage.jpg')
                              : CachedNetworkImage(
                                  imageUrl: user!.photoURL!,
                                  placeholder: (context, url) => Image.asset(
                                      'assets/icons/defaultimage.jpg'),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          'assets/icons/defaultimage.jpg'),
                                  fit: BoxFit.cover,
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
                              user?.displayName ?? 'User',
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.white),
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
                              onPressed: () {},
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
                  const SizedBox(height: 30),
                  ProfileMenuItem(
                    title: "Notifications",
                    icon: Icons.notifications,
                    onPressed: () {
                      // Navigate to the Notifications screen
                    },
                  ),
                  ProfileMenuItem(
                    title: "Help Centre",
                    icon: Icons.info,
                    onPressed: () {
                      // Navigate to the Privacy Policy screen
                    },
                  ),
                  ProfileMenuItem(
                    title: "Privacy Policy",
                    icon: Icons.privacy_tip,
                    onPressed: () {
                      // Navigate to the Terms and Conditions screen
                    },
                  ),
                  ProfileMenuItem(
                    title: "Terms and Conditions",
                    icon: Icons.gavel,
                    onPressed: () {
                      // Navigate to the Terms and Conditions screen
                    },
                  ),
                  const SizedBox(height: 50),
                  LogoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),

      // Nav Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
    );
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
          authService.signOut(); // Call the signOut method from AuthService
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
