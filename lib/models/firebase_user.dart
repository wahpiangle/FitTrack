import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUser {
  final String uid;
  final String photoUrl;
  final String displayName;
  final String username;
  final List<dynamic> requestSent;
  final List<dynamic> requestReceived;
  final String email;
  final List<dynamic> friends;
  final DateTime createdAt;
  final DateTime updatedAt;

  FirebaseUser({
    required this.uid,
    required this.photoUrl,
    required this.displayName,
    required this.username,
    required this.requestSent,
    required this.requestReceived,
    required this.email,
    required this.friends,
    required this.createdAt,
    required this.updatedAt,
  });

  static Future<FirebaseUser> fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Future.value(FirebaseUser(
      uid: doc.id,
      photoUrl: data['photoUrl'],
      displayName: data['displayName'],
      username: data['username'],
      requestSent: data['requestSent'] ?? [],
      requestReceived: data['requestReceived'] ?? [],
      email: data['email'],
      friends: data['friends'] ?? [],
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    ));
  }
}
