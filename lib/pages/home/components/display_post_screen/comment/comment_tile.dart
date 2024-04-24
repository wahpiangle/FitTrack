import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/comments.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/pages/user_profile/user_profile_page.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';
import 'package:intl/intl.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  late Future<FirebaseUser> userFuture;
  @override
  void initState() {
    userFuture = FirebaseUserService.getUserByUid(widget.comment.postedBy);
    super.initState();
  }

  void navigateToUserProfile(FirebaseUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserProfilePage(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final user = snapshot.data!;
        return ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: GestureDetector(
            onTap: () => navigateToUserProfile(user),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: snapshot.data!.photoUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/icons/defaultimage.jpg',
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => navigateToUserProfile(user),
                child: Text(
                  snapshot.data!.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                DateFormat('EEEE, hh:mm:ss a').format(widget.comment.date),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          subtitle: Text(
            widget.comment.comment,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
