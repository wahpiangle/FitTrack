import 'package:flutter/material.dart';
import 'components/bottom_nav_bar.dart';
import 'package:group_project/pages/exercises_screen.dart';
import 'package:group_project/pages/history_screen.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:group_project/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final int _selectedIndex = 4;
  final List<Widget Function()> pages = [
        () => const Home(),
        () => const HistoryScreen(),
        () => const ProfileScreen(),
        () => const ExercisesListScreen(),
        () => const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < pages.length) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => pages[index]()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // center title horizontally
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Will lead to the Search friends page or your desired action
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1A1A1A), // Set background color to black
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
                    SizedBox(height: 20), // Gap between the heading and content
                  ],
                ),

                Row(
                  children: [
                    SizedBox(
                      width: 110, // size of profile image
                      height: 110, // size of profile image
                      child: ClipOval(
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(), // Placeholder for when the image is loading
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/defaultimage.jpg'), // Placeholder for when an error occurs
                          fit: BoxFit.cover,
                          imageUrl: '',
                        ),
                      ),
                    ),
                    const SizedBox(width: 20), // The gap between the image and username
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       const Padding(
                        padding: EdgeInsets.only(left: 10), // slightly move the username to the right side
                          child: Text(
                            'Xxx', // Username text
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 12), // Gap between the username and "Edit Profile" button
                        Container(
                          width: 150, // Set the width of the button
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFE1F0CF), // Set the background color to green
                            borderRadius: BorderRadius.circular(100), // Rounded corners
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => const FirstRoute()),
                              // );
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
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
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
              ],
            ),
          ),
          LogoutButton(), // Call logout class at the bottom of the screen
        ],
      ),
      // Nav Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
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
                      const SizedBox(width: 12), // Adjust the spacing as needed
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
                    Icons.arrow_forward_ios, // next icon
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12), // gap between the menu item
      ],
    );
  }
}

class LogoutButton extends StatelessWidget {
  final AuthService authService = AuthService();
  LogoutButton({Key? key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 15,
      child: SingleChildScrollView(//to prevent overflow
      child: SizedBox(
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
      ),
      ),
    );
  }
}


