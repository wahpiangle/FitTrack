import 'package:cloud_firestore/cloud_firestore.dart';

class Reaction {
  String id; //this id is the user's id
  String imageUrl;
  String postId;

  Reaction({
    required this.id,
    required this.imageUrl,
    required this.postId,
  });

  static Reaction fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return Reaction(
      id: doc.id,
      imageUrl: doc['imageUrl'],
      postId: doc['postId'],
    );
  }
}
