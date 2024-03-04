import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/friend/friend_tab.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/layout/user_profile_provider.dart';
import 'package:group_project/pages/exercise/components/custom_exercise.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final User? user;
  final String title;
  final bool showBackButton;
  final int pageIndex;

  const TopNavBar({
    super.key,
    required this.pageIndex,
    required this.title,
    required this.user,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    String profileImage =
        Provider.of<UserProfileProvider>(context).profileImage;

    Widget leadingWidget;

    if (showBackButton) {
      leadingWidget = IconButton(
        icon: Theme(
          data: ThemeData(iconTheme: const IconThemeData(color: Colors.white)),
          child: const Icon(Icons.arrow_back_ios),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else if (pageIndex == 3) {
      leadingWidget = TextButton(
        onPressed: () {
          CustomExerciseDialog.showNewExerciseDialog(context, objectBox);
        },
        child: const Text(
          'New',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (pageIndex == 0) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendPage(title: '',)),
          );
        },
      );
    } else {
      leadingWidget = IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          // Default action, e.g., open the navigation drawer
        },
      );
    }


    return AppBar(
      backgroundColor: const Color(0xFF1A1A1A),
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: pageIndex == 0 ? 'Dancing Script' : null,
            fontSize : pageIndex == 0 ? 30 : null,
          ),
        ),
      ),
      centerTitle: true,
      leading: leadingWidget,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              width: 40,
              height: 40,
              child: CachedNetworkImage(
                imageUrl: profileImage,
                imageBuilder: (context, imageProvider) => ClipOval(
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
