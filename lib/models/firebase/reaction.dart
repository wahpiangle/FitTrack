import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';

class Reaction {
  String id;
  String imageUrl;
  String postId;
  FirebaseUser? postedByUser;
  DateTime date;

  Reaction({
    required this.id,
    required this.imageUrl,
    required this.postId,
    this.postedByUser,
    required this.date,
  });

  static Reaction fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return Reaction(
      id: doc.id,
      imageUrl: doc['imageUrl'],
      postId: doc['postId'],
      date: doc['date'].toDate(),
    );
  }

  static Future<void> addUserInfo(Reaction reaction) async {
    final FirebaseUser user =
        await FirebaseUserService.getUserByUid(reaction.id);
    reaction.postedByUser = user;
  }
}
