import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Post {
  @Id()
  int id;
  final String caption;
  final String firstImageUrl;
  final String secondImageUrl;
  final DateTime date;
  final String postedBy;
  final int workoutSessionId;
  final String postId;

  Post({
    this.id = 0,
    required this.caption,
    required this.firstImageUrl,
    required this.secondImageUrl,
    required this.date,
    required this.postedBy,
    required this.workoutSessionId,
    required this.postId,
  });

  static fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return Post(
      postId: doc.id,
      caption: doc.data()['caption'],
      firstImageUrl: doc.data()['firstImageUrl'],
      secondImageUrl: doc.data()['secondImageUrl'],
      date: doc.data()['date'].toDate(),
      postedBy: doc.data()['postedBy'],
      workoutSessionId: doc.data()['workoutSessionId'],
    );
  }

  static fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Post(
      postId: doc.id,
      caption: doc.data()!['caption'],
      firstImageUrl: doc.data()!['firstImageUrl'],
      secondImageUrl: doc.data()!['secondImageUrl'],
      date: doc.data()!['date'].toDate(),
      postedBy: doc.data()!['postedBy'],
      workoutSessionId: doc.data()!['workoutSessionId'],
    );
  }
}
